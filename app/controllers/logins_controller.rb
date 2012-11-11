class LoginsController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]

  def new
    #
  end

  # login
  def create
    domain = Domain.find_by_name(params[:domain])
    user = User.where(:name => params[:name], :domain_id => domain.try(:id)).first
    if user.try(:authenticate, params[:password])
      session[:current_user_id] = user.id
      if user.superadmin?
        redirect_to root_url
      elsif user.admin?(domain)
        redirect_to domain
      else
        redirect_to [domain, user]
      end
    else
      flash[:notice] = 'Wrong credentials, please try again.'
      render 'logins/new'
    end
  end

  # login
  def destroy
    @_current_user = session[:current_user_id] = nil
    flash[:notice] = "Logout successful. Have a nice day!"
    redirect_to new_login_path
  end
end
