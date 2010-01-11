class Admin::StoriesController < AdminController
  before_filter :get_story, :except => [:index, :new, :create] 
  
  def index
    @stories = Story.all
  end
  
  def show
  end
  
  def new
    @story = Story.new
  end
  
  def create
    @story = Story.new(params[:story])
    if @story.save
      flash[:notice] = "Successfully created story."
      redirect_to [:admin, @story]
    else
      render :action => 'new'
    end
  end
  
  def edit

  end
  
  def update
    if @story.update_attributes(params[:story])
      flash[:notice] = "Successfully updated story."
      redirect_to [:admin, @story]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @story.destroy
    flash[:notice] = "Successfully destroyed story."
    redirect_to admin_stories_url
  end
  
  private 
  
    def get_story
      @story = Story.find_by_id(params[:id])
    end
end
