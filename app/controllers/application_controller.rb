# -*- encoding : utf-8 -*-
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

  def update_session_expiry
    if current_user
      session[:login_expires_at] = 30.minutes.from_now
    end
  end

  def authenticate
    respond_to do |format|
      format.html do
        if current_user && session[:login_expires_at].kind_of?(Time) && session[:login_expires_at] > Time.now
          update_session_expiry
        else
          session[:return_to] = request.fullpath
          log_out "Please log in!"
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
  rescue => e
    logger.error "Error: #{e}"
    log_out "Error.", :error
  end

  def log_out(msg, msg_type=:notice)
    current_user = session[:current_user_id] = nil
    redirect_to new_login_url, msg_type => msg
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

  def filtered_index
    resource_klass = self.class.controller_name.classify.constantize
    @initials = resource_klass.select(:name).map do |obj|
      obj.name.first.upcase
    end.uniq.compact
    @filter_initial = params[:filter].to_s.upcase

    # Assign the list to the right variable, e.g. @forwards.
    objs = if @filter_initial.present? && @initials.include?(@filter_initial)
             resource_klass.where("name like '#{@filter_initial}%'")
           else
             resource_klass.latest
           end
    inst_var_name = "@#{resource_klass.to_s.downcase.pluralize}"
    instance_variable_set(inst_var_name, objs)

    respond_to do |format|
      format.html
      format.json { render json: instance_variable_get(inst_var_name) }
    end
  end

end
