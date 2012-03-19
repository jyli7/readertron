module ApplicationHelper
  def bookmarklet_for_user(user)
    "javascript: (function(){document.body.appendChild(document.createElement('script')).src='#{Domain.url}/reader/bookmarklet.js?token=#{user.share_token}';})();"
  end

  def markdown(text)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    clean(renderer.render(text))
  end
  
  def mdown(text)
    text = text.gsub(%r{(^|\s)([*_])(.+?)\2(\s|$)}x, %{\\1<em>\\3</em>\\4})
    text = text.gsub(/[\n]+/, "<br><br>")
    raw(text)
  end
  
  def comment_date(date)
    if date >= 1.month.ago
      date.strftime("(#{time_ago_in_words(date)} ago)")
    else
      date.strftime("(%b #{date.day}, %Y %I:%M %p)")
    end
  end
end