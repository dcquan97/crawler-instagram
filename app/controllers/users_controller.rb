class UsersController < ApplicationController
  before_action :authorize, only: [:destroy]


  def destroy
    if current_user.password_digest == params[params[:password]]
      current_user.destroy
      session.clear
      redirect_to root_path
      SendEmailJob.set(wait: 2.seconds).perform_later(current_user)
    else
      redirect_to profile_path
    end
  end

  def new
    if current_user.present?
      redirect_to dashboard_path
    end
  end

end
