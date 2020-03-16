class BillingJob < ApplicationJob
  queue_as :mail

  def perform(user)
    @user = user
    UserMailer.create_billing_email(@user.email).deliver_later
  end
end
