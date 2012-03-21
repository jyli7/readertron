class Feed < ActiveRecord::Base  
  has_many :subscriptions, :dependent => :destroy
  has_many :users, :through => :subscriptions
  has_many :posts, :dependent => :destroy

  after_save :get_favicon
  before_destroy :remove_favicon
  
  validates_presence_of :feed_url
  validates_uniqueness_of :feed_url

  module OPML
    class Outline
      include HappyMapper
        tag 'outline'
        attribute :title, String
        attribute :text, String
        attribute :type, String
        attribute :xmlUrl, String
        attribute :htmlUrl, String
        has_many :outlines, Outline
    end
  end
  
  def self.clean_url(url)
    if url.match(/^http/).present?
      url = url.gsub("www.", "") if url.match(/http:\/\/www\./).present?
    else
      url = url.gsub("www.", "") if url.match(/^www\./).present?
      url = "http://#{url}"
    end
    url
  end
  
  def self.shared
    where(shared: true)
  end
  
  def self.unshared
    where(shared: false)
  end
  
  def self.all_for_opml(opml)
    OPML::Outline.parse(opml).map(&:xmlUrl).map {|feed_url| create_if_needed(clean_url(feed_url))}
  end
  
  def self.create_if_needed(feed_url)
    if (f = find_by_feed_url(feed_url))
      return f
    else
      fz = Feedzirra::Feed.fetch_and_parse(feed_url)
      if !fz.is_a?(Fixnum) && fz.present?
        if (f = find_by_title(fz.title))
          return f
        end
        if (f = find_by_url(fz.url))
          return f
        end
      end
    end
    return create(feed_url: feed_url)
  end
  
  def self.fuzzy_find(field, string)
    where("#{field} like '%#{string}%'")
  end

  def self.refresh
    t, failed_updates, failed_fetches, fallback_failed_updates, fallback_failed_fetches = Time.now, [], [], [], []
    posts_count = Post.count
    feed_things = unshared.map {|f| (f.cached_feedzirra && f.cached_feedzirra.feed_url) ? f.cached_feedzirra : f.feed_url}
    virgin_feeds, updatable_feeds = feed_things.partition {|f| f.is_a?(String)}
    
    Feedzirra::Feed.update(updatable_feeds, max_redirects: 5, timeout: 10,
      on_success: lambda {|fz| if feed = find_by_feed_url(fz.feed_url) then feed.refresh(fz) end},
      on_failure: lambda do |fz, response_code, c, d|
        failed_updates << [fz.feed_url, response_code]
        begin
          fz2 = Feedzirra::Feed.parse(Feedzirra::Feed.fetch_raw(fz.feed_url))
          if feed = find_by_feed_url(fz.feed_url) then feed.refresh(fz2) end
        rescue Exception => e
          fallback_failed_updates << [fz.feed_url, "Fallback failure: #{e}"]
        end
      end
    )
    Feedzirra::Feed.fetch_and_parse(virgin_feeds, max_redirects: 5, timeout: 10,
      on_success: lambda {|feed_url, fz| if feed = find_by_feed_url(feed_url) then feed.refresh(fz) end},
      on_failure: lambda do |feed_url, response_code, response_header, response_body|
        failed_fetches << [feed_url, response_code]
        begin
          fz2 = Feedzirra::Feed.parse(Feedzirra::Feed.fetch_raw(feed_url))
          if feed = find_by_feed_url(feed_url) then feed.refresh(fz2) end
        rescue Exception => e
          fallback_failed_fetches << [feed_url, "Fallback failure: #{e}"]
        end
      end
    )
    Report.create(report_type: "Feed.refresh", content: {
      time: Time.now - t,
      posts: Post.count - posts_count,
      failed_updates: failed_updates, 
      fallback_failed_updates: fallback_failed_updates,
      failed_fetches: failed_fetches,
      fallback_failed_fetches: fallback_failed_fetches
    })
  end
  
  def cached_feedzirra
    Rails.cache.read("feedzirra-#{id}")
  end
  
  def cache_feedzirra(feedzirra)
    Rails.cache.write("feedzirra-#{id}", feedzirra)
  end
  
  def refresh(feedzirra=nil)
    t = Time.now
    if feedzirra.nil?
      if cached_feedzirra.present? && cached_feedzirra.feed_url.present?
        Feedzirra::Feed.update(cached_feedzirra, max_redirects: 5, timeout: 10,
          on_success: lambda {|fz| feedzirra = fz},
          on_failure: lambda do |fz, response_code, c, d|
            begin
              feedzirra = Feedzirra::Feed.parse(Feedzirra::Feed.fetch_raw(fz.feed_url))
            rescue Exception => e
              puts "Fallback failed: #{e}"
            end
          end
        )
      else
         Feedzirra::Feed.fetch_and_parse(feed_url, max_redirects: 5, timeout: 10,
          on_success: lambda {|feed_url, fz| feedzirra = fz},
          on_failure: lambda do |feed_url, response_code, response_header, response_body|
            begin
              feedzirra = Feedzirra::Feed.parse(Feedzirra::Feed.fetch_raw(feed_url))
            rescue Exception => e
              puts "Fallback failed: #{e}"
            end
          end
        )
      end
    end
    return "Fetch failed" if (feedzirra.is_a?(Fixnum) || feedzirra.nil?)

    entries = (ne = feedzirra.new_entries).empty? ? feedzirra.entries : ne
    cutoff = (latest_post ? latest_post.published : nil)
    
    entries.each_with_index do |entry, i|
      break if entry.published && cutoff && (entry.published < cutoff)
      posts.create({
        title: entry.title, 
        author: entry.author,
        url: entry.url,
        content: (entry.content || entry.summary), 
        published: (entry.published || (begin Date.parse(entry.summary) rescue i.days.ago end))
      })
    end
    
    rehydrate(feedzirra, cutoff)
    puts "-" * 80
    puts "Time: #{Time.now - t}"
    puts "-" * 80
  rescue Exception => e
    puts "#" * 80
    puts "EXCEPTION: #{e}"
    puts "#" * 80
  end
  
  def rehydrate(feedzirra, cutoff)
    update_attributes(title: feedzirra.title, url: feedzirra.url, last_modified: cutoff)
    cache_feedzirra(feedzirra)
  end
  
  def latest_post
    posts.order("published ASC").last
  end
  
  def get_favicon(force=false)
    if url.present? && (url_changed? || force)
      begin
        `curl http://www.google.com/s2/favicons?domain=#{URI.parse(url).host} > #{Rails.root}/app/assets/images/favicons/#{id}.png`
      rescue
        `cp #{Rails.root}/app/assets/images/favicons/default.png #{Rails.root}/app/assets/images/favicons/#{id}.png`
      end
    end
  end
  
  def remove_favicon
    `rm #{Rails.root}/app/assets/images/favicons/#{id}.png`
  end
  
  def self.resolve_duplicates
    marked_titles = {}
    duplicated_feeds = unshared.select {|f| find_all_by_title(f.title).length > 1}.select {|f| f.title.present?}
    duplicated_feeds.each do |dupe|
      if marked_titles[dupe.title].nil?
        ActiveRecord::Base.transaction do
          copies = find_all_by_title(dupe.title).map(&:id)
          good = find(copies.first)
          copies[1..-1].each do |bad_id|
            bad = find(bad_id)
            bad.posts.each {|post| good.posts << post}
            bad.reload.subscriptions.each { |subscription| good.subscriptions << subscription }
            bad.reload.destroy
          end
        end
        marked_titles[dupe.title] = true
      end
    end
  end

end