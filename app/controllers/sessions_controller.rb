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
      if params[:remember_me] == 'true'
        cookies[:auth_token] = {
          value: @user.auth_token,
          expires: 1.hours.from_now.utc
        }
      else
        session[:user_id] = @user.id
      end
      redirect_to dashboard_path, notice: 'Success login!'
    else
      redirect_to login_path, alert: 'Not found account'
    end
  end

  def edit
    @user = User.find_by(id: current_user.id)
  end

  def update
    if params[:avatar].present?
      current_user.update(avatar: params[:avatar])
      redirect_to dashboard_path, notice: 'Update success.'
    elsif params[:full_name].blank?
      current_user.update(full_name: params[:full_name])
      redirect_to dashboard_path, notice: 'Update success.'
    elsif params[:website].size > 1
      current_user.update(website: params[:website])
      redirect_to dashboard_path, notice: 'Update success.'
    elsif params[:decription].size > 1
      current_user.update(decription: params[:decription])
      redirect_to dashboard_path, notice: 'Update success.'
    elsif current_user&.authenticate(params[:current_password]) && params[:new_password] == params[:password_confirmation]
      current_user.update(password: params[:new_password])
      redirect_to dashboard_path, notice: 'Update success.'
    else
      redirect_to profile_path
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path
  end

  def crawler
    if current_user.card_token.blank?
      redirect_to billing_index_path
    else
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
end
