class UsersController < ApplicationController
  load_resource :domain

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
    @user.write_attribute(:domain_id => @domain.id)

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
    # TODO: replace with dynamic attr_accessible, see
    # <http://asciicasts.com/episodes/237-dynamic-attr-accessible>.
    params.delete(:name)
    params.delete(:domain)

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
    domain = @user.domain
    @user.destroy

    respond_to do |format|
      format.html { redirect_to domain }
      format.json { head :no_content }
    end
  end

end
