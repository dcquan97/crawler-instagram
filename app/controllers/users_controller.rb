class UsersController < ApplicationController
  def index
    @user = current_user
    @image = Image.first
  end

  def sign_in
    user = User.find_by(email: params[:email], encrypted_password: params[:password])
    if user.nil?
      redirect_to sign_in_path
    else
      session[:user_id] = user.id
      redirect_to dashboard_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

end
