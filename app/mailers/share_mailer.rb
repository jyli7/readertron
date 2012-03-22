class ShareMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "notifications@readertron.com"
  
  def new_comment_email(user, comment)
    @user = user
    @comment = comment
    mail(to: user.email, subject: "Readertron: #{comment.user.name} commented on \"#{truncate(comment.post.title, length: 30)}\" (post_id: #{comment.post.id})")
  end
end
