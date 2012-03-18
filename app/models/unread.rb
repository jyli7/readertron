class Unread < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  validates_presence_of :post
  validates_presence_of :user
  
  after_create :increment_subscription
  before_destroy :decrement_subscription
  
  validates_uniqueness_of :user_id, :scope => :post_id
  
  def self.for_feed(feed_id)
    joins("JOIN posts ON unreads.post_id = posts.id JOIN feeds ON posts.feed_id = feeds.id").where("feeds.id = #{feed_id}")
  end
  
  def self.shared
    joins("JOIN posts ON unreads.post_id = posts.id JOIN feeds ON posts.feed_id = feeds.id").where("feeds.shared = 't'")
  end
  
  def self.unshared
    joins("JOIN posts ON unreads.post_id = posts.id JOIN feeds ON posts.feed_id = feeds.id").where("feeds.shared = 'f'")
  end
  
  def increment_subscription
    sub = post.feed.subscriptions.find_by_user_id(user.id)
    sub.unread_count = sub.unread_count + 1
    sub.save
  end
  
  def decrement_subscription
    sub = post.feed.subscriptions.find_by_user_id(user.id)
    if sub.present?
      sub.unread_count = sub.unread_count - 1
      sub.save
    end
  end
end
