class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  
  after_create :generate_unreads
  before_destroy :remove_unreads
  
  validates_uniqueness_of :user_id, :scope => :feed_id
  
  def self.unshared
    joins("JOIN feeds ON subscriptions.feed_id = feeds.id").where("feeds.shared = ?", false)
  end
  
  def self.shared
    joins("JOIN feeds ON subscriptions.feed_id = feeds.id").where("feeds.shared = ?", true)
  end

  def generate_unreads
    feed.posts.order("published DESC").first(10).each do |post|
      user.unreads.create(post: post)
    end
  end
  
  def remove_unreads
    user.unreads.for_feed(feed.id).destroy_all
  end
end