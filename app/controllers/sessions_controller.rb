class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    @user = User.find_by(email: params[:email], password_digest: params[:password])
    if @user.present?
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end

  def edit
    @user = User.find_by(id: current_user.id)
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  def update
    if params["/profile"][:password] == current_user.encrypted_password
      current_user.update_attributes!(username: params["/profile"][:username], email: params["/profile"][:email])
      redirect_to dashboard_path
    else
      redirect_to profile_path
    end
  end
end
