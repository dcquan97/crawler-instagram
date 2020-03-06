class PasswordController < ApplicationController
	def create
		binding.pry
		user = User.find_by_email(params[:email])
		user_password_reset = user
		user.send_password_reset if user
		redirect_to root_path, notice: "Email sent with password reset instructions"
		ForgotPasswordJob.set(wait: 4.seconds).perform_later(user)
	end
	def edit
		@user = User.find_by_reset_password_token(params[:id])
	end
	def update
		@user = User.find_by_reset_password_token!(params[:id])
		if @user.reset_password_sent_at < 2.minutes.ago
			redirect_to new_password_path, alert: "Password reset has expired"
		elsif @user.update(set_password)
			redirect_to root_path, notice: "Password has been reset!"
		else
			render :edit
		end
	end
	private
	def set_password
		params.require(:user).permit(:password, :password_confirmation)
	end
end
