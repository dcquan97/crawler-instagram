class UserMailer < ApplicationMailer
  def delete_account_email(user)
    @user = user
    mail(to: @user.email, subject: "Sample Email")
  end

  def done_get_post_email(user)
    @user = user
    mail(to: @user.email, subject: "Sample Email")
  end
end
