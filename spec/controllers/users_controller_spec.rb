require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "sets @user to a new User object" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe "POST create" do
    
    context "successful user sign up" do
      it "redirects to sign in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end
    
    context "failed user sign up" do
      let(:customer) { double(:customer, successful?: false, error_message: 'message') }
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "renders the new template" do
        expect(response).to render_template :new
      end
      it "sets the flash error message" do
        expect(flash[:error]).to be_present
      end
    end
    
    context "with invalid personal info" do
      it "renders the :new template" do
        post :create, user: {email: "dcprime@gmail.com", password: "password"}
        expect(response).to render_template :new
      end
    end
  end
  
  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 5 }
    end
    it "sets @user" do
      set_current_user
      get :show, id: current_user.id
      expect(assigns(:user)).to eq(current_user)
    end
  end
  
  describe "GET following" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :following }
    end
  end
  
  describe "POST follow" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :follow, id: 3 }
    end
    it "adds the user to the current_user's following_users" do
      darren = Fabricate(:user)
      set_current_user(darren)
      larissa = Fabricate(:user)
      post :follow, id: larissa.id
      expect(darren.following_users.first).to eq(larissa)
    end
    it "redirects to the following page" do
      darren = Fabricate(:user)
      set_current_user(darren)
      larissa = Fabricate(:user)
      post :follow, id: larissa.id
      expect(response).to redirect_to following_path
    end
    it "renders the show page after invalid requests" do
      darren = Fabricate(:user)
      set_current_user(darren)
      post :follow, id: darren.id
      expect(response).to render_template(:show)
    end
  end
  
  describe "POST unfollow" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :unfollow, id: 2 }
    end
    context "with valid input" do
      it "removes the user from the current_user's following_users" do
        darren = Fabricate(:user)
        set_current_user(darren)
        larissa = Fabricate(:user)
        darren.following_users << larissa
        post :unfollow, id: larissa.id
        expect(darren.following_users.count).to eq(0)
      end
      it "redirects to the following page" do
        darren = Fabricate(:user)
        set_current_user(darren)
        larissa = Fabricate(:user)
        darren.following_users << larissa
        post :unfollow, id: larissa.id
        expect(response).to redirect_to following_path
      end
    end
    context "with invalid input" do
      it "does not remove the user from another user's following_users" do
        darren = Fabricate(:user)
        set_current_user(darren)
        larissa = Fabricate(:user)
        charles = Fabricate(:user)
        charles.following_users << larissa
        post :unfollow, id: larissa.id
        expect(charles.following_users.first).to eq(larissa)
      end
      it "renders to the following page" do
        darren = Fabricate(:user)
        set_current_user(darren)
        larissa = Fabricate(:user)
        charles = Fabricate(:user)
        charles.following_users << larissa
        post :unfollow, id: larissa.id
        expect(response).to render_template :following
      end
    end
  end
  
end