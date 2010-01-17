class Admin::TweetsController < AdminController
  before_filter :get_tweet, :except => [:index, :new, :create] 
  
  def index
    @tweets = Tweet.paginate :page => params[:page], :per_page => 50, :order => "created_at DESC"
  end
  
  def show
  end
  
  def new
    @tweet = Tweet.new
  end
  
  def create
    @tweet = Tweet.new(params[:tweet])
    if @tweet.save
      flash[:notice] = "Successfully created tweet."
      redirect_to [:admin, @tweet]
    else
      render :action => 'new'
    end
  end
  
  def edit

  end
  
  def update
    if @tweet.update_attributes(params[:tweet])
      flash[:notice] = "Successfully updated tweet."
      redirect_to [:admin, @tweet]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @tweet.destroy
    flash[:notice] = "Successfully destroyed tweet."
    redirect_to admin_tweets_url
  end
  
  private 
  
    def get_tweet
      @tweet = Tweet.find_by_id(params[:id])
    end
end
