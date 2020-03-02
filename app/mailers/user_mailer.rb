class UserMailer < ApplicationMailer
  def password_reset(user)
  	@user = user
  	mail to: @user.email, subject: "Password reset your a account"
  end
end
