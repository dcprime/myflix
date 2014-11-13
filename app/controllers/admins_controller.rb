class AdminsController < ApplicationController
  
  before_action :ensure_admin
  
  def ensure_admin
    unless current_user.admin?
      flash[:error] = "You do not have permission to do that"
      redirect_to home_path
    end
  end
  
end