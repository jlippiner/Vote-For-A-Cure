class Admin::StatusesController < ApplicationController
  before_filter :get_status, :except => [:index, :new, :create] 
  
  def index
    @statuses = Status.all
  end
  
  def show
  end
  
  def new
    @status = Status.new
  end
  
  def create
    @status = Status.new(params[:status])
    if @status.save
      flash[:notice] = "Successfully created status."
      redirect_to [:admin, @status]
    else
      render :action => 'new'
    end
  end
  
  def edit

  end
  
  def update
    if @status.update_attributes(params[:status])
      flash[:notice] = "Successfully updated status."
      redirect_to [:admin, @status]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @status.destroy
    flash[:notice] = "Successfully destroyed status."
    redirect_to admin_statuses_url
  end
  
  private 
  
    def get_status
      @status = Status.find_by_id(params[:id])
    end
end
