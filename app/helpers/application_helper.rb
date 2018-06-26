module ApplicationHelper

  def app_config(id)
    case id
    when :thumb_width
      569
    when :thumb_height
      320
    end
  end

  def msg(id, *str)

    case id
    when :info_acc_reg
      "Please check your email to activate your account."
    when :succ_user_update
      "Profile updated."
    when :succ_user_delete
      "User #{str[1]} (id: #{str[0]}) deleted."
    when :danger_login_required
      "Please log in."
    when :info_logout_required
      "You are already logged in."
    when :succ_account_activated
      "Your account is now activated."
    when :danger_invalid_acc_activation_link
      "Link invalid. It may have expired, please try again."
    when :info_password_reset_mail_sent
      "Email sent with password reset instructions"
    when :danger_contact_the_admin
      "Something went wrong. Try again or contact the website administrator."
    when :succ_password_reset
      "Your password is now updated."
    when :danger_token_expired
      "The token link has expired."
    when :warning_account_not_active
      "Account not activated. Please check your email for the activation"+
        " link."
    when :wrong_password
      "The current password does not match."
    end

  end

end
