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

  def create_billing_email(user)
    @user = user
    mail(to: @user.email, subject: "Done Add Checkout Method Email")
  end
end
