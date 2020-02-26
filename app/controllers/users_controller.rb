class UsersController < ApplicationController
  def index
    @image = Image.first
  end
  def edit
    @user = User.find(params[:id])
  end
end
