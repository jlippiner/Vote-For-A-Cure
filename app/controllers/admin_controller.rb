class AdminController < ApplicationController
  before_filter :login_required, :check_authorized
  
  def index
    
  end
  
  def destroy
    flash.notice = "Goodbye Mr. #{current_user.login}"
    logout_keeping_session!
    redirect_to root_url    
  end
  
    
  private
  
  def check_authorized
    authorized = ['jlippiner','billstrong']
    unless authorized.include?(current_user.login)
      flash.error = "Restricted Access"
      logout_keeping_session!
      redirect_to root_url
    end
  end
end