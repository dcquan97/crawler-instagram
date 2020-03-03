class ApplicationController < ActionController::Base

  def current_user
    return unless cookies[:auth_token]
    @current_user ||= User.find_by_auth_token(cookie[:auth_token])
  end

end
