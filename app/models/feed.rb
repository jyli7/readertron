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
    feed_urls = OPML::Outline.parse(opml).map(&:xmlUrl).reject {|feed_url| find_by_feed_url(feed_url).present?}
    Feedzirra::Feed.fetch_and_parse(feed_urls).inject([]) do |feeds, feed|
      feeds << make_if_necessary(feed[1], feed_url[0])
    end
  end
  
  def self.make_if_necessary(feed, feed_url)
    if !feed.is_a?(Fixnum) && feed.present?
      find_or_create_by_url(feed.url, 
        feed_url: feed.feed_url,
        title: feed.title.try(:strip), 
        last_modified: feed.last_modified
      )
    else
      find_or_create_by_feed_url(feed_url)
    end
  end
  
  def self.refresh
    Feed.find_in_batches do |feeds|
      Feedzirra::Feed.fetch_and_parse(feeds.map(&:feed_url)).each do |feed_url, feedzirra|
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