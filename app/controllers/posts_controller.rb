class PostsController < ApplicationController
  before_action :authorize
  def index
  end

  def show
    @instagram = current_user.instagrams.find_by(id: params[:id])
    @images    = @instagram.images
    @videos    = @instagram.videos
  end
end
