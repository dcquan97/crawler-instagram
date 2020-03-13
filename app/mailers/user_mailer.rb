class UserMailer < ApplicationMailer
  def password_reset(user)
  	@user = user
  	mail to: @user.email, subject: "Password reset your a account"
  end
  # Method send mail when create account
  def confirmation_user(user)
  	@user = user
  	mail to: @user.email, subject: "Let's activation a account to join the application of us."
  end
  def delete_account_email(user)
    @user = user
    mail(to: @user.email, subject: "Sample Email")
  end

  def done_get_post_email(user)
    @user = user
    mail(to: @user.email, subject: "Sample Email")
  end

  def error_get_post_email(user)
    @user = user
    mail(to: @user.email, subject: "Sample Email")
  end
end
