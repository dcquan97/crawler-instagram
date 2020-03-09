class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize, only: [:edit, :destroy, :update]

  def new
  end

  def create
    @user = User.find_by(email: params["/login"][:email])
    if @user&.authenticate(params["/login"][:password])
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end

  def edit
    @user = User.find_by(id: current_user.id)
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  def update
    if current_user&.authenticate(params[:password])
      current_user.update_attributes!(username: params[:username], email: params[:email])
      redirect_to dashboard_path
    else
      redirect_to profile_path
    end
  end

  def crawler
    current_user.images.all.destroy_all
    current_user.videos.all.destroy_all
    crawl = Crawler::Html.new("https://www.instagram.com/#{current_user.username}/")
    crawl.parsing
    crawl.data.each do |n|
      like_counter      = n.like_count
      title             = n.content
      a_image           = n.image
      a_video           = n.video
      current_instagram = current_user.instagrams.create(like_counter: like_counter, content: title)
      if a_image.class == String
        Image.create(instagram_id: current_instagram.id,file: a_image)
      elsif a_image != []
        a_image.each do |image_url|
          Image.create(instagram_id: current_instagram.id,file: image_url)
        end
      elsif a_video.class == String
          Video.create(instagram_id: current_instagram.id,file: a_video)
      else
        a_video.each do |video_url|
          Video.create(instagram_id: current_instagram.id,file: video_url)
        end
      end
    end
    redirect_to dashboard_path
  end
end
