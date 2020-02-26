class UsersController < ApplicationController
  def index
    @imgur = Imgur.first
  end
end
