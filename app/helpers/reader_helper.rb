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
end
