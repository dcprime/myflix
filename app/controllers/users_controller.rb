class UsersController < ApplicationController
  
  before_action :require_user, only: [:show, :following, :follow, :unfollow]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      stripe_payment
      invitation = Invitation.find_by(friend_email: @user.email)
      if invitation
        Relationship.create(follower_id: invitation.user_id, following_id: @user.id)
        Relationship.create(follower_id: @user.id, following_id: invitation.user_id)
      end
      UserMailer.welcome_email(@user).deliver
      flash[:notice] = "You have successfully registered"
      redirect_to sign_in_path
    else
      flash[:error] = "Please correct the fields below. Your card has not been charged."
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
    @relationship = Relationship.new
  end
  
  def following
  end
  
  def follow
    relationship = Relationship.new(follower_id: current_user.id, following_id: params[:id])
    if relationship.valid?
      relationship.save
      redirect_to following_path
    else
      @user = User.find(params[:id])
      render :show
    end
  end
  
  def unfollow
    user = User.find(params[:id])
    rel = Relationship.where(follower: current_user, following: user).first
    if user && rel
      rel.destroy
      redirect_to following_path
    else
      render :following
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
  
  def stripe_payment
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = params[:stripeToken]
    begin
      charge = Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => token,
        :description => "membership fee for #{@user.email}"
      )
    rescue Stripe::CardError => e
      flash[:error] = e.message
    end
  end
  
end