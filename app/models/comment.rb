class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  validates_presence_of :user
  validates_presence_of :post
  validates_presence_of :content
  
  after_create :notify_relevant_users
  
  def notify_relevant_users
    relevant_users = [post.sharer] | (post.comments.map(&:user) - [user])
    (relevant_users).each do |u|
      ShareMailer.new_comment_email(u, self).deliver
    end
  end
end
