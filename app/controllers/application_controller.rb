class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login

  private

  def current_user
    @_current_user ||= session[:current_user_id] &&
        User.find(session[:current_user_id])
  end

  def require_login
    if !current_user
      redirect_to new_login_url, :notice => "Please log in!"
    end
  end
end
