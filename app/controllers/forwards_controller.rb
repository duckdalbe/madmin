class ForwardsController < ApplicationController
  before_filter :load_domain
  before_filter :load_forward, :except => [:new, :create]
  before_filter :authorize, :except => [:create]

  def new
    @forward = Forward.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forward }
    end
  end

  def show
    @user = @forward.user
  end

  def edit
  end

  def create
    if ! current_user.superadmin? &&
        ! current_user.admin?(@domain) &&
        ! current_user.name == params['forward']['name']
      render403
      return
    end
    params['forward']['domain_id'] = @domain.id
    @forward = Forward.new(params[:forward])


    respond_to do |format|
      if @forward.save
        format.html { redirect_to root_url, notice: 'Forward was successfully created.' }
        format.json { render json: root_url, status: :created, location: @forward }
      else
        format.html { render action: "new" }
        format.json { render json: @forward.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    params.delete(:name)
    params.delete(:domain)

    respond_to do |format|
      if @forward.update_attributes(params[:forward])
        format.html { redirect_to root_url, notice: 'Forward was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forward.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @forward.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Forward was deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def load_forward
    @forward = Forward.find(params[:id])
  end

  def authorize
    # TODO: let users edit own forwards. (forward.name == user.name)
    if ! current_user.superadmin? &&
        ! current_user.admin?(@domain) &&
        ! current_user.id == @user.try(:id)
      render403
      return
    end
  end
end
