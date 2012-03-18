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
    where("shared = 't'")
  end
  
  def self.unshared
    where("shared = 'f'")
  end
  
  def self.all_for_opml(opml)
    OPML::Outline.parse(opml).map(&:xmlUrl).map {|feed_url| find_or_create_by_feed_url(clean_url(feed_url))}
  end
  
  def self.fuzzy_find(field, string)
    where("#{field} like '%#{string}%'")
  end

  def self.refresh
    Feed.find_in_batches do |feeds|
      Feedzirra::Feed.fetch_and_parse(feeds.reject {|f| f.shared?}.map(&:feed_url)).each do |feed_url, feedzirra|
        next if feedzirra.is_a?(Fixnum) || feedzirra.nil? # Fetch failed.

        if (feed = Feed.find_by_feed_url(feed_url))
          feed.refresh(feedzirra)
        else
          feed = Feed.fuzzy_find(:feed_url, URI.parse(feed_url).host).first
          feed.update_attributes(feed_url: feed_url) if feed.present?
        end
      end
    end
  end
  
  def refresh(feedzirra=Feedzirra::Feed.fetch_and_parse(self.feed_url))
    hydrate(feedzirra)
    
    feedzirra.entries.each do |entry| # Going backwards through time.
      attrs = {
        title: entry.title, 
        author: entry.author,
        url: entry.url,
        content: (entry.content || entry.summary), 
        published: entry.published
      }
      if entry.published && (entry.published < self.latest) && post = Post.find_by_url(entry.url)
        post.refresh(attrs)
      else
        posts.create(attrs)
      end
    end

    self.update_attributes(last_modified: feedzirra.last_modified)
  end
  
  def hydrate(feedzirra)
    update_attributes(title: feedzirra.title, url: feedzirra.url)
  end
  
  def latest
    last_modified || Date.parse("Aug. 7th, 1987")
  end
  
  def get_favicon(force=false)
    if url_changed? || force
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