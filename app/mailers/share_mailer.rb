class ShareMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "notifications@readertron.com"
  
  def new_comment_email(user, comment)
    @user = user
    @comment = comment
    mail(to: user.email, subject: "#{comment.user.name} commented on \"#{comment.post.title}\" (post_id: #{comment.post.id})")
  end
end
