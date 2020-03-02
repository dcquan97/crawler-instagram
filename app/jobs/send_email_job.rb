class SendEmailJob < ActiveJob::Base
  queue_as :mail

  def perform user
    @user = user
    ExampleMailer.sample_email(@user).deliver_later
  end
end
