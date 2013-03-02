class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  # TODO: use strong_parameters: <http://weblog.rubyonrails.org/2012/3/21/strong-parameters/>.
  before_filter :filter_params
  load_and_authorize_resource
  # ensure authorization is checked.
  check_authorization
  helper_method :current_user

  rescue_from CanCan::AccessDenied do |exception|
    render403
  end

  rescue_from ActiveRecord::DeleteRestrictionError do |exc|
    flash[:error] = exc
  end

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

  def filter_params
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
end
