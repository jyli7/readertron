module ReaderHelper
  def pretty_date(date)
    date.strftime("%b #{date.day}, %Y %I:%M %p")
  end
end
