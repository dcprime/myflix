
def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  visit sign_out_path
end

def clear_current_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id])
end

def post_user_to_session
  darren = Fabricate(:user)
  post :create, email: darren.email, password: darren.password
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end

def get_stripe_token_id
  Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  @token ||= Stripe::Token.create(
    :card => {
    :number => "4242424242424242",
    :exp_month => 11,
    :exp_year => 2016,
    :cvc => "123"
    }
  )
  @token.id
end

def get_invalid_stripe_token_id
  Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  @token ||= Stripe::Token.create(
    :card => {
    :number => "4000000000000002",
    :exp_month => 11,
    :exp_year => 2016,
    :cvc => "123"
    }
  )
  @token.id
end