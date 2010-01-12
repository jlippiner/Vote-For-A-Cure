class Admin::DirectMessagesController < AdminController
  before_filter :get_direct_message, :except => [:index, :new, :create] 
  
  def index
    @direct_messages = DirectMessage.all
  end
  
  def show
  end
  
  def new
    @direct_message = DirectMessage.new({:active => true})
  end
  
  def create
    @direct_message = DirectMessage.new(params[:direct_message])
    if @direct_message.save
      flash[:notice] = "Successfully created direct message."
      redirect_to [:admin, @direct_message]
    else
      render :action => 'new'
    end
  end
  
  def edit

  end
  
  def update
    if @direct_message.update_attributes(params[:direct_message])
      flash[:notice] = "Successfully updated direct message."
      redirect_to [:admin, @direct_message]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @direct_message.destroy
    flash[:notice] = "Successfully destroyed direct message."
    redirect_to admin_direct_messages_url
  end
  
  private 
  
    def get_direct_message
      @direct_message = DirectMessage.find_by_id(params[:id])
    end
end
