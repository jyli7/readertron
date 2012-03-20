class Report < ActiveRecord::Base
  serialize :content
  
  def self.daily
    user_stats = {}
    User.all.each do |user|
      stats = {}
      stats[:unread_count] = user.unreads.count
      stats[:bookmarklets_today] = user.feed.posts.where("id = original_post_id AND url != '#quickpost' AND created_at > ?", [1.day.ago]).count
      stats[:quickposts_today] = user.feed.posts.where("url = '#quickpost' AND created_at > ?", [1.day.ago]).count
      stats[:shares_today] = user.feed.posts.where("id != original_post_id AND created_at > ?", [1.day.ago]).count
      stats[:comments_today] = user.comments.where("created_at > ?", 1.day.ago).count
      stats[:subscriptions] = user.subscriptions.count
      stats[:last_login] = user.current_sign_in_at
      user_stats[user.name] = stats
    end
    create({report_type: "Daily site report", content: {feed_count: Feed.count, post_count: Post.count, unread_count: Unread.count, comment_count: Comment.count, share_count: Post.shared.count, users: user_stats}})
  end
end
