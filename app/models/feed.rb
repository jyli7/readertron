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
  
  def self.shared
    where("shared = 't'")
  end
  
  def self.unshared
    where("shared = 'f'")
  end
  
  def self.all_for_opml(opml)
    OPML::Outline.parse(opml).map(&:xmlUrl).map {|feed_url| find_or_create_by_feed_url(feed_url)}
  end

  def self.refresh
    Feed.find_in_batches do |feeds|
      Feedzirra::Feed.fetch_and_parse(feeds.reject {|f| f.shared?}.map(&:feed_url)).each do |feed_url, feedzirra|
        next if feedzirra.is_a?(Fixnum) || feedzirra.nil? # Fetch failed.

        if (feed = Feed.find_by_feed_url(feed_url))
          feed.hydrate(feedzirra)

          feedzirra.entries.each do |entry| # Going backwards through time.
            break if entry.published && (entry.published < feed.latest)
            feed.posts.create(title: entry.title, url: entry.url, author: entry.author, content: (entry.content || entry.summary), published: entry.published)
          end

          feed.update_attributes(last_modified: feedzirra.last_modified)
        end # TODO: If feed_urls don't match up, find the appropriate Feed object and reset with feedzirra.feed_url.
      end
    end
  end
  
  def hydrate(feedzirra)
    update_attributes(title: feedzirra.title, url: feedzirra.url)
  end
  
  def latest
    last_modified || Date.parse("Aug. 7th, 1987")
  end
  
  def get_favicon
    if url_changed?
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