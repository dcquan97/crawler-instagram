class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize, only: [:edit, :destroy, :update, :crawler, :index]

  def new
    if current_user.present?
      redirect_to dashboard_path
    end
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password]) && @user.confirmation == true
      params[:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to dashboard_path, notice: 'Success login!'
    else
      redirect_to login_path, alert: 'Not found account'
    end
  end

  def edit
    @user = User.find_by(id: current_user.id)
  end

  def update
    if current_user.present?
      current_user.update_attributes!(user_params)
      redirect_to dashboard_path, notice: 'Update success.'
    elsif current_user&.authenticate(params[:current_password]) && params[:new_password] == params[:password_confirmation]
      current_user.update(password: params[:new_password])
      redirect_to dashboard_path, notice: 'Update success.'
    else
      redirect_to profile_path, alert: 'Update error.'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  def crawler
      current_user.update status: false
      CrawlerJob.set(wait: 2.seconds).perform_later(current_user)
      redirect_to dashboard_path
    end
  end

  def index
    @account    = current_user
    @instagrams = current_user.instagrams.order_by_time_post
  end

  private

  def stripe_params
    params.permit :stripeEmail, :stripeToken
  end

  def user_params
    params.permit(:full_name, :website, :decription, :avatar)
  end
end
