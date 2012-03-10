class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  
  after_create :generate_unreads
  
  validates_uniqueness_of :user_id, :scope => :feed_id
  
  def generate_unreads
    feed.posts.order("published DESC").first(10).each do |post|
      user.unreads.create(post: post)
    end
  end
end