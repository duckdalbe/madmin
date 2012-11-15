class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  private

  def current_user
    @_current_user ||= session[:current_user_id] &&
        User.find(session[:current_user_id])
  end

  def current_user=(user)
    @_current_user = user
  end

  def authenticate
    respond_to do |format|
      format.html do
        if !current_user
          session[:return_to] = request.fullpath
          flash[:notice] = "Please log in!"
          redirect_to new_login_url
        end
      end
      format.json do
        authenticate_or_request_with_http_basic do |username, password|
          user = User.find_by_email(username)
          if user.try(:authenticate, password)
            self.current_user = user
          else
            false
          end
        end
      end
    end
  end

  def render403
    respond_to do |format|
      format.html do
        render 'errors/403', :status => :forbidden
      end
      format.json do
        render :text => "Forbidden".to_json, :status => :forbidden
      end
    end
  end

  def load_domain
    @domain = Domain.find(params[:domain_id])
  end
end
