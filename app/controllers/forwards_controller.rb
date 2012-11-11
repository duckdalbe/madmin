class ForwardsController < ApplicationController
  before_filter :load_domain
  before_filter :load_forward, :except => [:new, :create]

  def new
    @forward = Forward.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forward }
    end
  end

  def edit
  end

  def create
    @forward = Forward.new(params[:forward])

    respond_to do |format|
      if @forward.save
        format.html { redirect_to @domain, notice: 'Forward was successfully created.' }
        format.json { render json: @domain, status: :created, location: @forward }
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
        format.html { redirect_to @domain, notice: 'Forward was successfully updated.' }
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
      format.html { redirect_to @domain, notice: 'Forward was deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def load_forward
    @forward = Forward.find(params[:id])
  end
end
