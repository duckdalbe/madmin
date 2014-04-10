class UsersController < ApplicationController
  load_resource :domain, except: :myself

  def myself
    respond_to do |format|
      format.html { redirect_to [current_user.domain, current_user] }
      format.json { render json: current_user }
    end
  end

  def index
    filtered_index
  end

  def confirm_destroy
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def edit
  end

  def create
    @user.domain_id = @domain.id
    @user.role = ROLES.first

    respond_to do |format|
      if @user.save
        format.html {
          redirect_to [@domain, @user], notice: 'User was successfully created.'
        }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {
          redirect_to [@user.domain, @user],
              notice: 'User was successfully updated.'
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if ! @user.destroyable?
      # TODO: respond to json.
      flash[:error] = 'Account may not be deleted.'
      redirect_to :back
      return false
    end

    domain = @user.domain
    @user.destroy

    respond_to do |format|
      format.html { redirect_to domain }
      format.json { head :no_content }
    end
  end

end
