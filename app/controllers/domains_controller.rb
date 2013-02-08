class DomainsController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @domains }
    end
  end

  def confirm_destroy
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @domain }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @domain }
    end
  end

  def filter_params
    if request['action'] == 'create'
      @user_params = params['domain'].delete('user')
    end
  end

  def create
    if @domain.save
      @user = User.new(@user_params)
      @user.name = 'postmaster'
      @user.role = 'admin'
      @user.domain_id = @domain.id

      if ! @user.save
        @domain.delete
      end
    end

    respond_to do |format|
      if @domain.errors.blank? && @user.errors.blank?
        format.html {
          redirect_to @domain,
              notice: "Domain #{@domain.name} was successfully created."
        }
        format.json { render json: @domain, status: :created, location: @domain }
      else
        format.html { render action: "new" }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @domain.destroy
        format.html {
          redirect_to domains_url,
              notice: "Domain #{@domain.name} was successfully deleted."
        }
        format.json { head :no_content }
      else
        format.html { redirect_to @domain, alert: @domain.errors[:base] }
        format.json { render json: @domain.errors[:base], status: :conflict }
      end
    end
  end

end
