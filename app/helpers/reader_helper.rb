module ReaderHelper
  def pretty_date(date)
    if date >= 1.month.ago
      date.strftime("%b #{date.day}, %Y %I:%M %p (#{time_ago_in_words(date)} ago)")
    else
      date.strftime("%b #{date.day}, %Y %I:%M %p")
    end
  end
  
  def li_classes(subscription, feed_id)
    classes = []
    classes << "selected" if subscription.feed.id == feed_id.to_i
    classes << "unread" if subscription.unread_count > 0
    classes.join(" ")
  end
  
  def unread_count(subscription)
     subscription.unread_count > 0 ? "(#{subscription.unread_count})" : ""
  end
  
  def star_class(post)
    if (share = Post.find_all_by_original_post_id(post.id).select {|share| share.feed.title == current_user.email}.first.presence)
      return "star-active" if share.note.blank?
    end
    "star-inactive"
  end
  
  def email_class(post)
    if (share = Post.find_all_by_original_post_id(post.id).select {|share| share.feed.title == current_user.email}.first.presence)
      return "email-active" if share.note.present?
    end
    "email-inactive"
  end
end
