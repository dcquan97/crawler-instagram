class UsersController < ApplicationController
  before_action :authorize

  def index
    @images = current_user.images
  end

  def destroy
    if current_user.password_digest == params[params[:password]]
      current_user.destroy
      session.clear
      redirect_to root_path
      SendEmailJob.set(wait: 20.seconds).perform_later(current_user)
    else
      redirect_to profile_path
      # render json: {
      #   error: "Wrong password."
      # }, status: :not_found
    end
  end
end
