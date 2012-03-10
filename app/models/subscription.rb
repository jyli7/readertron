class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  
  after_create :generate_unreads
  
  def generate_unreads
    feed.posts.order("published DESC").first(10).each do |post|
      user.unreads.create(post: post)
    end
  end
end