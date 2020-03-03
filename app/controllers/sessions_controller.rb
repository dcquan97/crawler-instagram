class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def create
    @user = User.find_by(email: params[:email], password: params[:password])
    if !@user.nil?
      if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def destroy
    cookies.delete :auth_token
    redirect_to root_path
  end
end
