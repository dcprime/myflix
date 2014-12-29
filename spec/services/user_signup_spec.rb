require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    
    context "with valid personal info and valid card" do
      before { ActionMailer::Base.deliveries.clear }
      after { ActionMailer::Base.deliveries.clear }
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token")
        expect(User.count).to eq(1)
      end
      it "stores the customer token from Stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token")
        expect(User.first.customer_token).to eq("abcdefg")
      end
      it "creates a Relationship where the inviter follows the friend" do
        darren = Fabricate(:user)
        invitation = Fabricate(:invitation, user_id: darren.id)
        invitation.update_column(:token, '12345')
        UserSignup.new(Fabricate.build(:user, email: invitation.friend_email, password: "password", full_name: "Alice Smith")).sign_up("some_stripe_token")
        expect(darren.following_users.last.full_name).to eq("Alice Smith")
      end
      it "creates a Relationship where the friend follows the invitor" do
        darren = Fabricate(:user)
        invitation = Fabricate(:invitation, user_id: darren.id)
        invitation.update_column(:token, '12345')
        UserSignup.new(Fabricate.build(:user, email: invitation.friend_email, password: "password", full_name: "Alice Smith")).sign_up("some_stripe_token")
        expect(User.find_by(full_name: "Alice Smith").following_users.last).to eq(darren)
      end
      it "sends out the email to the user" do
        UserSignup.new(Fabricate.build(:user, email: "alice@example.com")).sign_up("some_stripe_token")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["alice@example.com"])
      end
      it "sends the email containing the user's name" do
        UserSignup.new(Fabricate.build(:user, email: "alice@example.com", full_name: "Alice Smith")).sign_up("some_stripe_token")
        expect(ActionMailer::Base.deliveries.last.body.encoded).to include("Alice Smith")
      end
    end
    
    context "valid personal info and declined card" do
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: 'message')
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token")
        expect(User.count).to eq(0)
      end
    end
    
    context "with invalid personal info" do
      it "does not create the user" do
        UserSignup.new(User.new(email: "darren@example.com")).sign_up("some_stripe_token")
        expect(User.count).to eq(0)
      end
      it "does not charge the card" do
        expect(StripeWrapper::Customer).not_to receive(:create)
        UserSignup.new(User.new(email: "darren@example.com")).sign_up("some_stripe_token")
      end
      it "does not send the email with invalid inputs" do 
        UserSignup.new(User.new(email: "darren@example.com")).sign_up("some_stripe_token")
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
    
  end
end