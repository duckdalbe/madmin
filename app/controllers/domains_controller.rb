class DomainsController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @domains }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @domain }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @domain }
    end
  end

  def create
    respond_to do |format|
      if @domain.save
        format.html { redirect_to @domain, notice: 'Domain was successfully created.' }
        format.json { render json: @domain, status: :created, location: @domain }
      else
        format.html { render action: "new" }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @domain.destroy

    respond_to do |format|
      format.html { redirect_to domains_url }
      format.json { head :no_content }
    end
  end

end
