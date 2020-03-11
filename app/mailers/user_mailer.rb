class UserMailer < ApplicationMailer
  def delete_account_email(user)
    @user = user
    mail(to: @user.email, subject: "Delete Account Email")
  end

  def done_get_post_email(user)
    @user = user
    mail(to: @user.email, subject: "Done Get Post Email")
  end

  def error_get_post_email(user)
    @user = user
    mail(to: @user.email, subject: "Error Get Post Email")
  end
end
