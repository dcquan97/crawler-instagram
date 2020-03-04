class UsersController < ApplicationController
  before_action :authorize

  def index
    @images = current_user.images
  end
  def new
  end
  def create
  	@user = User.new(set_user)
  	if @user.save
  		redirect_to root_path, notice: "Account create successly!"
  	else
  		render :new
  	end
  end
  # Private method
  private
  def set_user
  	params.require(:users).permit(:username, :email, :password, :password_confirmation)
  end
end
