class UsersController < ApplicationController
  before_action :authorize, only: [:destroy, :show]

  def show
  end

  def destroy
    if current_user.password == params[params[:password]]
      current_user.destroy
      session.clear
      redirect_to root_path
      SendEmailJob.set(wait: 2.seconds).perform_later(current_user)
    else
      redirect_to profile_path, notice: 'Password not valid.'
    end
  end

  def new
    if current_user.present?
      redirect_to dashboard_path
    end
  end

end
