class UsersController < ApplicationController
  def index
    if !current_user.nil?
      @images = current_user.images
    else
      redirect_to root_path
    end
  end
end
