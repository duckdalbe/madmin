class ForwardsController < ApplicationController
  load_resource :domain

  def new
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
    @forward.write_attribute(:domain_id, @domain.id)

    respond_to do |format|
      if @forward.save
        format.html {
          redirect_to [@domain, @forward],
              notice: 'Forward was successfully created.'
        }
        format.json {
          render json: [@domain, @forward],
              status: :created, location: @forward
        }
      else
        format.html { render action: "new" }
        format.json {
          render json: @forward.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def update
    params.delete(:name)
    params.delete(:domain)

    respond_to do |format|
      if @forward.update_attributes(params[:forward])
        format.html {
          redirect_to [@domain, @forward],
              notice: 'Forward was successfully updated.'
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json {
          render json: @forward.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    f = @forward.dup
    @forward.destroy

    respond_to do |format|
      format.html {
        redirect_to (f.user ? [f.domain, f.user] : f.domain),
            notice: 'Forward was deleted.'
      }
      format.json { head :no_content }
    end
  end

end
