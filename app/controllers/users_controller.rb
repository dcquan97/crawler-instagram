class UsersController < ApplicationController
  def index
    @image = Image.first
  end
end
