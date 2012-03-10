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
    if Post.find_all_by_original_post_id(post.id).collect {|share| share.feed.title}.include?(current_user.email)
      "star-active"
    else
      "star-inactive"
    end
  end
end
