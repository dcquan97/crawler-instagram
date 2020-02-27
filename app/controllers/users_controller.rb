class UsersController < ApplicationController
  def index
    if !current_user.nil?
      @images = current_user.images
    end
  end
end
