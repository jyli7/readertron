class Feed < ActiveRecord::Base  
  has_many :subscriptions, :dependent => :destroy
  has_many :users, :through => :subscriptions
  has_many :posts, :dependent => :destroy
  
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

  def self.seed(feed_url)
    make_if_necessary(Feedzirra::Feed.fetch_and_parse(feed_url), feed_url)
  end
  
  def self.all_for_opml(opml)
    feeds = []
    to_subscribe, to_fetch = OPML::Outline.parse(opml).map(&:xmlUrl).partition {|feed_url| find_by_feed_url(feed_url).present?}
    to_subscribe.each do |feed_url|
      feeds << find_by_feed_url(feed_url)
    end
    Feedzirra::Feed.fetch_and_parse(to_fetch).each do |feed_url, feedzirra|
      feeds << make_if_necessary(feedzirra, feed_url)
    end
    feeds
  end
  
  def self.make_if_necessary(feedzirra, feed_url)
    if !feedzirra.is_a?(Fixnum) && feedzirra.present?
      find_or_create_by_url(feedzirra.url, 
        feed_url: feedzirra.feed_url,
        title: feedzirra.title.try(:strip), 
        last_modified: feedzirra.last_modified
      )
    else
      find_or_create_by_feed_url(feed_url)
    end
  end
  
  def self.refresh
    Feed.find_in_batches do |feeds|
      Feedzirra::Feed.fetch_and_parse(feeds.reject {|f| f.shared?}.map(&:feed_url)).each do |feed_url, feedzirra|
        next if feedzirra.is_a?(Fixnum) || feedzirra.nil?
        feed = Feed.find_by_feed_url(feed_url)
        if feed && feed.last_modified
          feedzirra.entries.each do |entry|
            puts entry.title
            if entry.published && feed.last_modified && (entry.published > feed.last_modified)
              feed.posts.create(title: entry.title, url: entry.url, author: entry.author, content: (entry.content || entry.summary), published: entry.published)
            else
              break
            end
          end
          feed.last_modified = feedzirra.last_modified
          feed.save
        elsif feed
          if feedzirra.last_modified.present?
            feedzirra.entries.each do |entry|
              puts entry.title
              feed.posts.create(title: entry.title, url: entry.url, author: entry.author, content: (entry.content || entry.summary), published: entry.published)
            end
            feed.last_modified = feedzirra.last_modified
            # TODO: Update the feed info itself, i.e., try to re-hydrate.
            feed.save
          end
        end
      end
    end
  end
end