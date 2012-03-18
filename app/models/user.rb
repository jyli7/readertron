class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :share_token, :name, :instapaper_username, :instapaper_password
  
  has_many :subscriptions, dependent: :destroy
  has_many :feeds, :through => :subscriptions, dependent: :destroy
  has_many :unreads, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  after_create :make_shared_feed_and_subscribe_others_to_it
  after_create :subscribe_to_all_shared_feeds
  after_create :make_share_token
  after_save :update_corresponding_feed_name
  before_destroy :kill_my_feed
  
  validates_presence_of :name
  
  def subscribe(feed_url)
    subscriptions.create(feed: Feed.find_or_create_by_feed_url(Feed.clean_url(feed_url)))
  end
  
  def bulk_subscribe(opml)
    Feed.all_for_opml(opml).each do |feed|
      subscriptions.create(feed: feed)
    end
  end
  
  def shared_unread_count
    shared_subscriptions.sum(&:unread_count)
  end
  
  def regular_subscriptions
    subscriptions.joins("JOIN feeds ON subscriptions.feed_id = feeds.id").where("feeds.shared = 'f'", false)
  end
  
  def shared_subscriptions
    subscriptions.joins("JOIN feeds ON subscriptions.feed_id = feeds.id").where("feeds.shared = ?", true)
  end
  
  def make_shared_feed_and_subscribe_others_to_it
    feed = Feed.create(title: name, feed_url: "#shared", shared: true)
    User.where("id != #{id}").each do |user|
      user.subscriptions.create(feed: feed)
    end
  end
  
  def feed
    Feed.where("feed_url = '#shared' AND title = '#{name}'").first
  end
  
  def kill_my_feed
    feed.destroy
  end
  
  def is_subscribed_to?(feed)
    subscriptions.find_by_feed_id(feed.id).present?
  end
  
  def subscribe_to_all_shared_feeds
    Feed.where(shared: true).where("id != '#{feed.id}'").each do |feed|
      subscriptions.create(feed: feed)
    end
  end
  
  def make_share_token
    update_attributes({share_token: SecureRandom.hex(20)})
  end
  
  def update_corresponding_feed_name
    if name_changed? && feed = Feed.where("feed_url = '#shared' AND title = '#{name_was}'").first
      feed.update_attributes(title: name)
    end
  end
end