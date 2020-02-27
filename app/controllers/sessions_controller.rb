class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    @user = User.find_by(email: params[:email], encrypted_password: params[:password])
    if !@user.nil?
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  def update
    if params[:password] == current_user.encrypted_password
      current_user.update_attributes!(username: params[:username], email: params[:email])
      redirect_to dashboard_path
    else
      redirect_to profile_path
    end
  end
end
