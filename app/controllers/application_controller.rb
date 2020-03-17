class ApplicationController < ActionController::Base
  helper_method :current_user,:remember, :forget, :log_out
  def current_user
    @current_user ||= User.find_by(remember_token: cookies[:remember_token]) if cookies[:remember_token]
  end
  helper_method :current_user

  def authorize
    redirect_to login_path unless current_user
  end


  # Create and Delete cookies
  private
  def remember(user)
    user.remember
    cookies.signed[:user_id] = {
      value: user.id,
      expires: 60.minutes
    }
    cookies[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
