class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
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
    if current_user.authenticate(params[:password])
      current_user.update(permit_update_params)
      Cloudinary::Uploader.upload(current_user.avatar.path)
      redirect_to dashboard_path
    else
      redirect_to profile_path
    end
  end

  private
  def permit_update_params
    params.permit(:username, :email, :avatar, :avatar_cache)
  end
end