# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.with(user: User.first).password_reset
    # UserMailer.password_reset(user).deliver
  end
  def confirmation_user
    UserMailer.with(user: User.first).confirmation_user
  end
end
