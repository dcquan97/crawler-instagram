class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
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
end
