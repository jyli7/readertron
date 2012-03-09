class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :unreads
  
  def subscribe(feed_url)
    subscriptions.create(feed: Feed.seed(feed_url))
  end
  
  def bulk_subscribe(opml)
    Feed.all_for_opml(opml).each do |feed|
      subscriptions.create(feed: feed)
    end
  end
end