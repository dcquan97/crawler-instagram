class ForgotPasswordJob < ApplicationJob
  queue_as :mail

  def perform(user)
  	@user = user
  	UserMailer.password_reset(@user).deliver_later
  end
end
