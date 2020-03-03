class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def create
    @user = User.find_by(email: params[:email], password: params[:password])
    if !@user.nil?
      cookies[:user_id] = @user.id
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def destroy
    cookies.delete :user_id
    redirect_to root_path
  end
end
