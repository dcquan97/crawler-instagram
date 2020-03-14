class UsersController < ApplicationController
  before_action :authorize, only: [:destroy, :show]

  def new
  end

  def create
  	@user = User.new(set_user)
  	if @user.save
      @user.send_email_activation
      UserMailer.confirmation_user(@user).deliver_later
  		redirect_to root_path, notice: "Please check your email to active account!"
  	else
  		redirect_to new_user_path
  	end
  end
  def show
  end

  def edit
    @user = User.find_by(confirmation_token: params[:id])
    @user.update_attributes(confirmed_at: Time.zone.now)
    confirm_duration = Time.zone.at(@user.confirmed_at - @user.confirmation_sent_at).strftime('%M').to_i.minutes
    if confirm_duration < 50.minutes
      @user.update_attributes(confirmation: true)
      redirect_to login_path
    else
      @user.send_email_activation_again
      UserMailer.confirmation_user(@user).deliver_later
      redirect_to root_path, notice: 'Please check your email to active account!'
    end
  end

  # Delete account and verify when delete
  def destroy
    if current_user.password == params[params[:password]]
      current_user.destroy
      cookies.clear
      redirect_to root_path
      SendEmailJob.set(wait: 2.seconds).perform_later(current_user)
    else
      redirect_to profile_path, notice: 'Password not valid.'
    end
  end

  # Private method
  private
  def set_user
  	params.require(:users).permit(:username, :email, :password, :password_confirmation)
  end
end
