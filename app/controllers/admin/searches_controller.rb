class Admin::SearchesController < ApplicationController
  before_filter :get_search, :except => [:index, :new, :create] 
  
  def index
    @searches = Search.all
  end
  
  def show
  end
  
  def new
    @search = Search.new
  end
  
  def create
    @search = Search.new(params[:search])
    if @search.save
      flash[:notice] = "Successfully created search."
      redirect_to [:admin, @search]
    else
      render :action => 'new'
    end
  end
  
  def edit

  end
  
  def update
    if @search.update_attributes(params[:search])
      flash[:notice] = "Successfully updated search."
      redirect_to [:admin, @search]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @search.destroy
    flash[:notice] = "Successfully destroyed search."
    redirect_to admin_searches_url
  end
  
  private 
  
    def get_search
      @search = Search.find_by_id(params[:id])
    end
end
