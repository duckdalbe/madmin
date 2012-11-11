class ForwardsController < ApplicationController
  # GET /forwards
  # GET /forwards.json
  #def index
  #  @forwards = Forward.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @forwards }
  #  end
  #end

  # GET /forwards/1
  # GET /forwards/1.json
  #def show
  #  @forward = Forward.find(params[:id])
  #  @user = User.where(:name => @forward.name, :domain_id => @forward.domain.id)

  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @forward }
  #  end
  #end

  # GET /forwards/new
  # GET /forwards/new.json
  def new
    @forward = Forward.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forward }
    end
  end

  # GET /forwards/1/edit
  def edit
    @forward = Forward.find(params[:id])
  end

  # POST /forwards
  # POST /forwards.json
  def create
    @forward = Forward.new(params[:forward])

    respond_to do |format|
      if @forward.save
        format.html { redirect_to @forward, notice: 'Forward was successfully created.' }
        format.json { render json: @forward, status: :created, location: @forward }
      else
        format.html { render action: "new" }
        format.json { render json: @forward.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forwards/1
  # PUT /forwards/1.json
  def update
    @forward = Forward.find(params[:id])
    params.delete(:name)
    params.delete(:domain)

    respond_to do |format|
      if @forward.update_attributes(params[:forward])
        format.html { redirect_to @forward, notice: 'Forward was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forward.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forwards/1
  # DELETE /forwards/1.json
  def destroy
    @forward = Forward.find(params[:id])
    @forward.destroy

    respond_to do |format|
      format.html { redirect_to forwards_url }
      format.json { head :no_content }
    end
  end
end
