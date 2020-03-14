class SessionsController < ApplicationController
  before_action :authorize, only: [:edit, :destroy, :update, :crawler, :index]

  def new
    if current_user.present?
      redirect_to dashboard_path
    end
  end

  def create
    @user = User.find_by(email: params["/login"][:email])
    if @user&.authenticate(params["/login"][:password])
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      redirect_to login_path , notice: "notice"
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
    if params[:full_name].size > 8
      current_user.update(full_name: params[:full_name])
      redirect_to dashboard_path
    elsif params[:website].size > 1
      current_user.update(website: params[:website])
      redirect_to dashboard_path
    elsif params[:decription].size > 1
      current_user.update(decription: params[:decription])
      redirect_to dashboard_path
    elsif current_user&.authenticate(params[:current_password]) && params[:new_password] == params[:password_confirmation]
      current_user.update(password: params[:new_password])
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

  def index
    @account    = current_user
    @instagrams = current_user.instagrams.order_by_time_post
  end
end
