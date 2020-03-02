class ForgotPasswordJob < ApplicationJob
  queue_as :default

  def perform(user)
  	queue_as :default
  	@user = user
  	UserMailer.delay_for(1.minutes).password_reset(@user).deliver_later(wait: 1.minutes)
  end
end
