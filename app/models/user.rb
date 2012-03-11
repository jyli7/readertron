class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :subscriptions, dependent: :destroy
  has_many :feeds, :through => :subscriptions, dependent: :destroy
  has_many :unreads, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  after_create :make_shared_feed_and_subscribe_others_to_it
  after_create :subscribe_to_all_shared_feeds
  before_destroy :kill_my_feed
  
  def subscribe(feed_url)
    subscriptions.create(feed: Feed.find_or_create_by_feed_url(feed_url))
  end
  
  def bulk_subscribe(opml)
    Feed.all_for_opml(opml).each do |feed|
      subscriptions.create(feed: feed)
    end
  end
  
  def entries_for_feed_id(feed_id)
    if (f = Feed.find_by_id(feed_id))
      @entries = f.posts.partition {|p| p.unread_for_user?(self)}.flatten.first(10)
    elsif feed_id == "shared"
      @entries = feeds.shared.collect {|f| f.posts}.flatten.partition {|p| p.unread_for_user?(self)}.flatten.first(10)
    elsif feed_id == "mine"
      @entries = feed.posts.first(10)
    else
      @entries = feeds.unshared.collect {|f| f.posts}.flatten.partition {|p| p.unread_for_user?(self)}.flatten.first(10)
    end
  end
  
  def total_unread_count
    subscriptions.sum(&:unread_count)
  end
  
  def shared_unread_count
    shared_subscriptions.sum(&:unread_count)
  end
  
  def regular_subscriptions
    # FIXME: Different db engine might not like this 't'.
    subscriptions.joins("JOIN feeds ON subscriptions.feed_id = feeds.id").where("feeds.shared = 'f'")
  end
  
  def shared_subscriptions
    # FIXME: Different db engine might not like this 't'.
    subscriptions.joins("JOIN feeds ON subscriptions.feed_id = feeds.id").where("feeds.shared = 't'")
  end
  
  def make_shared_feed_and_subscribe_others_to_it
    feed = Feed.create(title: email, feed_url: "#shared", shared: true)
    User.where("id != #{id}").each do |user|
      user.subscriptions.create(feed: feed)
    end
  end
  
  def feed
    Feed.where("feed_url = '#shared' AND title = '#{email}'").first
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
end