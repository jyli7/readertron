class Unread < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  validates_presence_of :post
  validates_presence_of :user
  
  validates_uniqueness_of :user_id, :scope => :post_id
  after_create :cache_published
  
  def self.for_feed(feed_id)
    joins("JOIN posts ON unreads.post_id = posts.id JOIN feeds ON posts.feed_id = feeds.id").where("feeds.id = #{feed_id}")
  end
  
  def self.shared
    joins("JOIN posts ON unreads.post_id = posts.id JOIN feeds ON posts.feed_id = feeds.id").where("feeds.shared = 't'")
  end
  
  def self.unshared
    joins("JOIN posts ON unreads.post_id = posts.id JOIN feeds ON posts.feed_id = feeds.id").where("feeds.shared = 'f'")
  end
  
  def cache_published
    update_attribute(:published, post.published)
  end
end
