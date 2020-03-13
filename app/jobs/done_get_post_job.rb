class DoneGetPostJob < ActiveJob::Base
  queue_as :mail

  def perform user
    @user = user
    UserMailer.done_get_post_email(@user).deliver_later
  end
end
