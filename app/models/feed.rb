class Feed < ActiveRecord::Base  
  has_many :subscriptions, :dependent => :destroy
  has_many :users, :through => :subscriptions

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
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    if !feed.is_a?(Fixnum) && feed.present?
      find_or_create_by_url(feed.url, feed_url: feed.feed_url, title: feed.title.try(:strip), last_modified: feed.last_modified)
    else
      find_or_create_by_feed_url(feed_url)
    end
  end
  
  def self.all_for_opml(opml)
    feed_urls = OPML::Outline.parse(opml).map(&:xmlUrl).reject {|feed_url| find_by_feed_url(feed_url).present?}
    Feedzirra::Feed.fetch_and_parse(feed_urls).inject([]) do |feeds, feed|
      feed_url, feed = feed
      if !feed.is_a?(Fixnum) && feed.present?
        feeds << find_or_create_by_url(feed.url, feed_url: feed.feed_url, title: feed.title.try(:strip), last_modified: feed.last_modified)
      else
        feeds << find_or_create_by_feed_url(feed_url)
      end
    end
  end
  
  def update
  end
end