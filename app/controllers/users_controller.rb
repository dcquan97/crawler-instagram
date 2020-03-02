class UsersController < ApplicationController
  before_action :authorize

  def index
      @images = current_user.images
  end
end
