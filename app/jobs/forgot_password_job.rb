class ForgotPasswordJob < ApplicationJob
  queue_as :mail
  queue_as :email

  def perform(user)
  	@user = user
  	UserMailer.password_reset(@user).deliver_later
  end
  # Set time when send active mailer
  def perform(user)
  	@user = user
  	UserMailer.confirmation_user(@user).deliver_later
  end
end
