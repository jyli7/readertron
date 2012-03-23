class Post < ActiveRecord::Base
  belongs_to :feed
  has_many :unreads, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  validates_uniqueness_of :url, unless: ->(post) { post.shared? }
  validates_presence_of :url
  validates_presence_of :title
  validates_presence_of :published
  validates_presence_of :content
  
  after_create :generate_unreads
  
  def self.for_user(user)
    joins("JOIN feeds ON feeds.id = posts.feed_id JOIN subscriptions ON feeds.id = subscriptions.feed_id")
      .where("subscriptions.user_id = #{user.id}")
  end
  
  def self.for_feed(feed_id)
    joins("JOIN feeds ON feeds.id = posts.feed_id").where("feeds.id = #{feed_id}")
  end
  
  def self.chron
    order("published ASC")
  end
  
  def self.revchron
    order("published DESC")
  end
  
  def self.revshared
    order("created_at DESC")
  end
  
  def self.unread_for_user(user)
    joins("JOIN unreads ON posts.id = unreads.post_id").where("unreads.user_id = #{user.id}")
  end
  
  def self.for_options(user, date_sort, items_filter, page=0, feed_id=nil)
    if feed_id.present?
      posts = feed_id == "shared" ? shared.for_user(user) : for_feed(feed_id)
    else
      posts = unshared.for_user(user)
    end
    
    posts = case date_sort
    when "chron"
      posts.chron
    when "revchron"
      posts.revchron
    when "revshared"
      posts.revshared
    end

    if items_filter == "unread"
      if page == 0
        posts = posts.unread_for_user(user)
        Rails.cache.write("#{user.id}_#{feed_id}_#{date_sort}", posts.map(&:id))
        return posts.first(10)
      else
        post_ids = Rails.cache.read("#{user.id}_#{feed_id}_#{date_sort}")
        posts = Post.find(Array.wrap(post_ids[page * 10..(page * 10) + 9]))
        return posts
      end
    else
      return posts.offset(page.to_i * 10).limit(10)
    end
  end
  
  def self.shared
    where("posts.shared = ?", true)
  end
  
  def self.unshared
    where("posts.shared = ?", false)
  end
  
  def refresh(attrs)
    update_attributes(attrs)
    shared_posts = Post.find_all_by_original_post_id(id).each do |share|
      share.update_attributes(attrs)
    end
  end
  
  def generate_unreads
    feed.users.each do |subscriber|
      subscriber.unreads.create(post: self)
    end
  end
  
  def unread_for_user?(user)
    unreads.find_by_user_id(user.id).present?
  end
  
  def sharer
    User.find_by_name(feed.title) if shared?
  end
end
