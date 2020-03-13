class UsersController < ApplicationController
  before_action :authorize, only: [:destroy, :index]
  def index
    @images = current_user.images
  end
  def new
  end
  def create
  	@user = User.new(set_user)
  	if @user.save
      @user.send_email_activation
      UserMailer.confirmation_user(@user).deliver_later
  		redirect_to root_path, notice: "Please check your email to active account!"
  	else
  		render :new
  	end
  end
  def edit
    @user = User.find_by(confirmation_token: params[:id])
    @user.update_attributes(confirmed_at: Time.zone.now)
    confirm_duration = Time.zone.at(@user.confirmed_at - @user.confirmation_sent_at).strftime('%M').to_i.minutes
    if confirm_duration < 50.minutes
      @user.update_attributes(confirmation: true)
      redirect_to dashboard_path
    else
      @user.send_email_activation_again
      UserMailer.confirmation_user(@user).deliver_later
      redirect_to root_path, notice: 'Please check your email to active account!'
    end
  end
  def destroy
    if current_user.password_digest == params[params[:password]]
      current_user.destroy
      session.clear
      redirect_to root_path
      SendEmailJob.set(wait: 2.seconds).perform_later(current_user)
    else
      redirect_to profile_path
    end
  end
  # Private method
  private
  def set_user
  	params.require(:users).permit(:username, :email, :password, :password_confirmation)
  end
end
