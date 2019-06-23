class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def comment_announce(user, comment)
    @comment = comment
    @user = user
    mail to: user.email, subject: "new comment on #{IceBlog.url}"
  end

  def reminder(user)
    @user = user
    @project_c = Project.where(published: false).count
    @blogp_c = BlogPost.where(published: false).count
    @blogp_update_c = Project.where("content_update IS NOT NULL").count
    @total = @project_c+@blogp_c+@blogp_update_c 

    if @total >= 1
      mail to: user.email, subject: "Reminder: Unpublished content"
    end
  end
    
end
