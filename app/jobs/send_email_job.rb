class SendEmailJob < ActiveJob::Base
  queue_as :mail

  def perform user
    @user = user
    UserMailer.delete_account_email(@user).deliver_later
  end
end
