require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => 4242424242424242,
        :exp_month => 11,
        :exp_year => 2016,
        :cvc => "314"
          }
        ).id
  end
  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
        :number => 4000000000000002,
        :exp_month => 11,
        :exp_year => 2016,
        :cvc => "314"
          }
        ).id
  end
  describe StripeWrapper::Charge do
    describe ".create" do
      before do
        StripeWrapper.set_api_key
      end
      it "charges the card succesfully", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999, 
          card: valid_token, 
          description: "a valid charge"
        )
        expect(response).to be_successful
      end

      context "with invalid card", :vcr do
        let(:response) { StripeWrapper::Charge.create(amount: 999, card: declined_card_token, description: "an invalid charge") }
        it "does not charge the card" do
          expect(response).to_not be_successful
        end
        it "contains an error message" do
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end
  
  describe StripeWrapper::Customer do
    describe ".create" do
      before do
        StripeWrapper.set_api_key
      end
      it "creates a customer with a valid card", :vcr do
        darren = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: darren,
          card: valid_token
        )
        expect(response).to be_successful
      end
      it "does not create a customer with a declined card", :vcr do
        darren = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: darren,
          card: declined_card_token
        )
        expect(response).not_to be_successful
      end
      
      it "returns the error message for declined cards", :vcr do
        darren = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: darren,
          card: declined_card_token
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
      
      it "returns the customer token for a valid card", :vcr do
        darren = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: darren,
          card: valid_token
        )
        expect(response.customer_token).to be_present
      end
    end
  end
end