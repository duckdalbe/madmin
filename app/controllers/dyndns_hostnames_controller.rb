# -*- encoding : utf-8 -*-
class DyndnsHostnamesController < ApplicationController
  load_resource :domain
  load_resource :user

  def confirm_destroy
  end

  def show
    respond_to do |format|
      format.html {
        redirect_to domain_user_path(@domain, @user, anchor: 'dyndns_hostnames')
      }
      format.json { render json: @dyndns_hostname }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: @dyndns_hostname }
    end
  end

  def edit
  end

  def create
    @dyndns_hostname.user_id = @user.id

    respond_to do |format|
      if @dyndns_hostname.save
        format.html {
          redirect_to(
              domain_user_path(@domain, @user, anchor: 'dyndns_hostname'),
              notice: "Hostname '#{@dyndns_hostname.name}' saved."
          )
        }
        format.json { render json: @dyndns_hostname, status: :created, location: @dyndns_hostname }
      else
        format.html { render action: "new" }
        format.json { render json: @dyndns_hostname.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @dyndns_hostname.update_attributes(params[:dyndns_hostname])
        format.html {
          redirect_to(
              domain_user_path(@domain, @user, anchor: 'dyndns_hostname'),
              notice: "Hostname updated: #{@dyndns_hostname.name}"
          )
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dyndns_hostname.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    respond_to do |format|
      format.html { 
        redirect_to domain_user_path(@domain, @user, anchor: 'dyndns_hostnames')
      }
      format.json { render json: DyndnsHostnames.all }
    end

  end

  def destroy
    user = @dyndns_hostname.user
    # TODO: handle failure
    @dyndns_hostname.destroy

    respond_to do |format|
      format.html {
        redirect_to domain_user_path(@domain, user, anchor: 'dyndns_hostnames')
      }
      format.json { head :no_content }
    end
  end
end
