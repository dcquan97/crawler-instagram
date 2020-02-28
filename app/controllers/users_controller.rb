class UsersController < ApplicationController
  before_action :authorize

  def index
    @images = current_user.images
  end

  def destroy
    current_user.destroy
    session.clear
    redirect_to root_path
  end
end
