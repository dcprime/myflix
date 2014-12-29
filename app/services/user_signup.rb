class UserSignup
  
  attr_reader :error_message
  
  def initialize(user)
    @user = user
  end
  
  def sign_up(stripe_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(
        :user => @user, 
        :card => stripe_token
      )
      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        handle_invitation(@user)
        UserMailer.welcome_email(@user).deliver
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Please correct the fields below. Your card has not been charged."
      self
    end
  end
  
  def successful?
    @status == :success
  end
  
  private
  
  def handle_invitation(user)
    invitation = Invitation.find_by(friend_email: user.email)
    if invitation
      Relationship.create(follower_id: invitation.user_id, following_id: user.id)
      Relationship.create(follower_id: user.id, following_id: invitation.user_id)
    end
  end
  
end