class SessionsController < ApplicationController
  before_action :authorize, only: [:edit, :destroy, :update, :crawler]

  def new
  end

  def create
    @user = User.find_by(email: params["/login"][:email])
    if @user&.authenticate(params["/login"][:password])
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
    if current_user&.authenticate(params[:password])
      current_user.update_attributes!(username: params[:username], email: params[:email])
      redirect_to dashboard_path
    else
      redirect_to profile_path
    end
  end

  def crawler
    current_user.update status: false
    CrawlerJob.set(wait: 2.seconds).perform_later(current_user)
    redirect_to dashboard_path
  end
end
