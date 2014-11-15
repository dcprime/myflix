class AdminsController < ApplicationController
  
  before_action :require_user
  before_action :ensure_admin
  
  def ensure_admin
    if !current_user.admin?
      flash[:error] = "You do not have permission to do that"
      redirect_to home_path
    end
  end
  
end