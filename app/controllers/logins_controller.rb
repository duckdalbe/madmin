class LoginsController < ApplicationController
  skip_before_filter :authenticate
  skip_load_and_authorize_resource
  skip_authorization_check

  def cookiesrequired
    if session[:cookietest] == true
      redirect_to new_login_url
    end
  end

  def new
    # No session-cookie means first request or cookies disabled. If it's the
    # first request the cookierequired-test will redirect back here and then
    # we've got a session.
    if cookies[sessionkey].blank?
      session[:cookietest] = true
      redirect_to cookiesrequired_login_url
      return
    end
  end

  # login
  def create
    domain = Domain.find_by_name(params[:domain])
    user = User.where(:name => params[:name], :domain_id => domain.try(:id)).first
    if user.try(:authenticate, params[:password])
      session[:current_user_id] = user.id
      update_session_expiry
      if session[:return_to].present?
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        redirect_to [domain, user]
      end
    else
      respond_to do |format|
        format.html {
          flash[:notice] = 'Wrong credentials, please try again.'
          render :new, :status => 401
        }
        format.json {
          head :unauthorized
        }
      end
    end
  end

  # login
  def destroy
    log_out "Logout successful. Have a nice day!"
  end

  private

  def sessionkey
    Rails.application.config.session_options[:key]
  end
end
