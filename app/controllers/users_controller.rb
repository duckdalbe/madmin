class UsersController < ApplicationController
  before_filter :load_domain, :except => [:home]
  before_filter :load_user, :except => [:new, :create, :home]
  before_filter :authorize, :except => [:home]

  # TODO: abandon @domain, use @user.domain
  # TODO: fix breadcrumb to include only allowed links (or none?)

  def home
    @user = current_user
    @domain = current_user.domain
    respond_to do |f|
      f.html { render action: 'show' }
      f.json { render json: @user }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def edit
  end

  def create
    @user = User.new(params[:user].merge(:domain_id => @domain.id))

    respond_to do |format|
      if @user.save
        format.html { redirect_to [@domain, @user], notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # TODO: replace with dynamic attr_accessible, see <http://asciicasts.com/episodes/237-dynamic-attr-accessible>
    params.delete(:name)
    params.delete(:domain)

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to [@user.domain, @user], notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    domain = @user.domain
    @user.destroy

    respond_to do |format|
      format.html { redirect_to domain }
      format.json { head :no_content }
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def authorize
    # Disallow if current_user isn't superadmin or domain-admin or request is
    # not for own user-data.
    if ! current_user.superadmin? &&
        ! current_user.admin?(@domain) &&
        current_user.id != @user.id
      render403
      return
    end
  end
end
