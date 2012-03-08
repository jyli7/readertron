class Post < ActiveRecord::Base
  belongs_to :feed
  
  validates_uniqueness_of :url
  validates_presence_of :url
  validates_presence_of :title
  validates_presence_of :published
  validates_presence_of :content
end
