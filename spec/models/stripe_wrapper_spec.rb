require 'spec_helper'

describe StripeWrapper::Charge do
  before do
    StripeWrapper.set_api_key
  end
  let(:token) do
    Stripe::Token.create(
        :card => {
          :number => card_number,
          :exp_month => 11,
          :exp_year => 2016,
          :cvc => "314"
      },
    ).id
  end
  
  context "with valid card" do
    let(:card_number) { "4242424242424242" }
    
    it "charges the card succesfully" do
      response = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(response).to be_successful
    end
  end
  
  context "with invalid card" do
    let (:card_number) { "4000000000000002" }
    let(:response) { StripeWrapper::Charge.create(amount: 300, card: token) }
    it "does not charge the card" do
      expect(response).to_not be_successful
    end
    it "contains an error message" do
      expect(response.error_message).to eq("Your card was declined.")
    end
  end
end