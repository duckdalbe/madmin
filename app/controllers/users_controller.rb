# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  load_resource :domain, except: :myself
  skip_load_and_authorize_resource only: :myself

  def myself
    authorize! :show, current_user
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
    respond_to do |format|
      domain = @user.domain
      if @user.destroy
        format.html { redirect_to [domain, 'users'] }
        format.json { head :no_content }
      else
        format.html { redirect_to [domain, @user], alert: @user.errors[:base] }
        format.json do
          render json: @user.errors[:base], status: :unprocessable_entity
        end
      end
    end
  end

end
