class ErrorGetPostJob < ActiveJob::Base
  queue_as :mail

  def perform user
    @user = user
    UserMailer.error_get_post_email(@user).deliver_later
  end
end
