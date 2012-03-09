class Unread < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  validates_presence_of :post
  validates_presence_of :user
  
  after_create :increment_subscription
  after_destroy :decrement_subscription
  
  def increment_subscription
    sub = post.feed.subscriptions.find_by_user_id(user.id)
    sub.unread_count = sub.unread_count + 1
    sub.save
  end
  
  def decrement_subscription
    sub = post.feed.subscriptions.find_by_user_id(user.id)
    sub.unread_count = sub.unread_count - 1
    sub.save
  end
end
