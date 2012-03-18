module ReaderHelper
  def pretty_date(date)
    if date >= 1.month.ago
      date.strftime("%b #{date.day}, %Y %I:%M %p (#{time_ago_in_words(date)} ago)")
    else
      date.strftime("%b #{date.day}, %Y %I:%M %p")
    end
  end
  
  def star_class(post)
    if (share = Post.find_all_by_original_post_id(post.id).select {|share| share.feed.title == current_user.name}.first.presence)
      return "star-active" if share.note.blank?
    end
    "star-inactive"
  end
  
  def share_with_note_class(post)
    if (share = Post.find_all_by_original_post_id(post.id).select {|share| share.feed.title == current_user.name}.first.presence)
      return "share-with-note-active" if share.note.present?
    end
    "share-with-note-inactive"
  end
  
  def clean(html)
    raw(Sanitize.clean(html, Sanitize::Config::RELAXED.merge({elements: Sanitize::Config::RELAXED[:elements] + ["style"]})))
  end
end
