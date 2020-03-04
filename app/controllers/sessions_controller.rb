class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize, only: [:index]

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      if params[:remember_me] == 'true'
        cookies[:auth_token] = {
          value: @user.auth_token,
          expires: 1.minutes.from_now.utc
        }
      else
        session[:user_id] = @user.id
      end
      redirect_to dashboard_path, notice: 'Success login!'
    else
      redirect_to login_path
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path
  end

  def update
    if params[:password] == current_user.password_digest
      current_user.update_attributes!(username: params[:username], email: params[:email])
      redirect_to dashboard_path
    else
      redirect_to profile_path
    end
  end
end