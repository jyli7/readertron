class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  
  after_create :generate_unreads
  
  validates_uniqueness_of :user_id, :scope => :feed_id
  
  def self.unshared
    joins("JOIN feeds ON subscriptions.feed_id = feeds.id").where("feeds.shared = 'f'")
  end
  
  def self.shared
    joins("JOIN feeds ON subscriptions.feed_id = feeds.id").where("feeds.shared = 't'")
  end
  
  def self.unread_hash_for_user(user)
    user.subscriptions.unshared.inject({}) {|hash, s| hash[s.feed.id] = s.unread_count; hash}
  end
  
  def self.shared_unread_hash_for_user(user)
    user.subscriptions.shared.inject({}) {|hash, s| hash[s.feed.id] = s.unread_count; hash}
  end
  
  def generate_unreads
    feed.posts.order("published DESC").first(10).each do |post|
      user.unreads.create(post: post)
    end
  end
end