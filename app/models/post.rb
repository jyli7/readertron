class Post < ActiveRecord::Base
  belongs_to :feed
  
  validates_uniqueness_of :url
  validates_presence_of :url
  validates_presence_of :title
  validates_presence_of :published
  validates_presence_of :content
  
  after_create :generate_unreads
  
  def self.unread_for_user(user)
    joins("LEFT JOIN unreads ON posts.id = unreads.post_id").where("unreads.user_id = #{user.id}")
  end
  
  def generate_unreads
    feed.users.each do |subscriber|
      subscriber.unreads.create(post: self)
    end
  end
end
