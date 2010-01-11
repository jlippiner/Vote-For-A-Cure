class AdminController < ApplicationController
  before_filter :login_required, :check_authorized

  def index

  end

  def destroy
    flash.notice = "Goodbye Mr. #{current_user.login}"
    redirect_to logout_path
  end


  private

  def check_authorized
    authorized = ['jlippiner','billstrong']
    unless authorized.include?(current_user.login)
      flash.error = "Restricted Access"
      redirect_to logout_path
    end
  end
end
