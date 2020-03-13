class ApplicationController < ActionController::Base
  helper_method :current_user
  def current_user
    @current_user ||= User.find_by!(auth_token: cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

  def authorize
    redirect_to login_path unless current_user
  end
end
