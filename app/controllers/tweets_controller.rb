class TweetsController < ApplicationController
  before_filter :login_required, :only => [:edit, :update, :show]

  def index
    @tweets = Tweet.all
  end

  def show
    @user = current_user
    logout_keeping_session!
  end

  def new
    @tweet = Tweet.new({:status => Status.random})
    @story = Story.random
    @profile_pics = User.find(:all, :conditions => "profile_image_url is not null and profile_image_url not like '%default_profile_normal.png%'", :order => "created_at DESC").collect {|x| x.profile_image_url}
    @tweet_reach = commify(User.find(:first, :select => "SUM(followers_count) as reach").reach)
    @tweet_count = commify(User.count(:conditions => 'login IS NOT null'))
  end

  def create
    @tweet = Tweet.new(params[:tweet])
    if @tweet.save
      session[:tweet_id] = @tweet.id
      redirect_to edit_tweet_path(@tweet)
    else
      render :action => 'new'
    end
  end

  def edit
    @tweet = Tweet.find_by_id(session[:tweet_id])
    if @current_user.tweet  # => check to see if they have already tweeted
      @tweet.delete # => remove since duplicate
      redirect_to @current_user.tweet
    elsif @tweet && @current_user
      update
    else
      flash.error = "Something went wrong.  Please try again."
    end
  end

  def update
    if @tweet.update_attributes({:user => @current_user})
      flash[:notice] = "Successfully updated tweet."
      Delayed::Job.enqueue TweetJob.new(@tweet.id)

      redirect_to @tweet
    else
      render :action => 'edit'
    end
  end

  private

  def commify(object)
    if object.is_a?(Numeric)
      object.to_s.gsub(/(\d)(?=(\d{3})+$)/,'\1,')
    else
      object
    end
  end

end
