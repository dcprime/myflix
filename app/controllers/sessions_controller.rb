class SessionsController < ApplicationController
  
  def new
    if logged_in?
      redirect_to home_path
    end
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.active?
        login_user!(user)
      else
        flash[:error] = "Your account has been suspended. Please contact customer service."
        redirect_to sign_in_path
      end
    else
      flash[:error] = "Your login information was incorrect"
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
  
  private
  
  def login_user!(user)
    session[:user_id] = user.id
    redirect_to :root
  end
  
end