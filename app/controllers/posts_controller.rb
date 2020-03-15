class PostsController < ApplicationController
  before_action :authorize
  def index
  end

  def show
    @instagram = current_user.instagrams.find_by(id: params[:id])
    @images    = @instagram.images
    @videos    = @instagram.videos
  end

  def update
    post = current_user.instagrams.find_by(id: params[:id])
    post.update(content: params[:content_text_aria_cur])
    redirect_to post_path(params[:id]), notify: 'Update success.'
  end
end
