class Feed < ActiveRecord::Base  
  has_many :subscriptions, :dependent => :destroy
  has_many :users, :through => :subscriptions
  has_many :posts, :dependent => :destroy
  
  after_save :get_favicon
  before_destroy :remove_favicon
  
  validates_presence_of :feed_url

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
    OPML::Outline.parse(opml).map(&:xmlUrl).map {|feed_url| find_or_create_by_feed_url(clean_url(feed_url))}
  end
  
  def self.fuzzy_find(field, string)
    where("#{field} like '%#{string}%'")
  end

  # def self.refresh(batch_size=10)
  #   find_in_batches(batch_size: batch_size) do |feeds|
  #     feed_things = feeds.reject {|f| f.shared?}.map {|f| f.cached_feedzirra || f.feed_url}
  #     virgin_feeds, updatable_feeds = feed_things.partition {|f| f.is_a?(String)}
  # 
  #     Feedzirra::Feed.update(updatable_feeds).each do |feed_url, feedzirra|
  #       if feed = find_by_feed_url(feed_url)
  #         feed.refresh(feedzirra)
  #       end
  #     end
  #     
  #     Feedzirra::Feed.fetch_and_parse(virgin_feeds).each do |feed_url, feedzirra|
  #       if feed = find_by_feed_url(feed_url)
  #         feed.refresh(feedzirra)
  #       end
  #     end
  #   end
  # end
  
  def cached_feedzirra
    Rails.cache.read("feedzirra-#{id}")
  end
  
  def cache_feedzirra(feedzirra)
    Rails.cache.write("feedzirra-#{id}", feedzirra)
  end
  
  def refresh(feedzirra=nil)
    t = Time.now
    if feedzirra.nil?
      if cached_feedzirra.present?
        feedzirra = Feedzirra::Feed.update(cached_feedzirra)
      else
        feedzirra = Feedzirra::Feed.fetch_and_parse(feed_url)
      end
    end
    return "Fetch failed" if (feedzirra.is_a?(Fixnum) || feedzirra.nil?)

    entries = (ne = feedzirra.new_entries).empty? ? feedzirra.entries : ne
    cutoff = (latest_post ? latest_post.published : nil)
    
    entries.each do |entry|
      break if entry.published && cutoff && (entry.published < cutoff)
      posts.create({
        title: entry.title, 
        author: entry.author,
        url: entry.url,
        content: (entry.content || entry.summary), 
        published: entry.published
      })
    end
    
    update(feedzirra)
    puts "-" * 80
    puts "Time: #{Time.now - t}"
    puts "-" * 80
  end
  
  def update(feedzirra)
    update_attributes(title: feedzirra.title, url: feedzirra.url, last_modified: feedzirra.last_modified)
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
end