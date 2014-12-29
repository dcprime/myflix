require 'spec_helper'

describe "create payment on succesful charge" do
  let(:event_data) do
    {
      "id"=> "evt_15F7NRBUofbCWxo1ZSTCnCLN",
      "created"=> 1419874341,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_15F7NRBUofbCWxo1CHexVa78",
          "object"=> "charge",
          "created"=> 1419874341,
          "livemode"=> false,
          "paid"=> true,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "captured"=> true,
          "card"=> {
            "id"=> "card_15F7NQBUofbCWxo1ZFRoBAFG",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 12,
            "exp_year"=> 2016,
            "fingerprint"=> "kmuttaUoZGSNB9xB",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "dynamic_last4"=> nil,
            "customer"=> "cus_5PxIjCIAH2Z2ta"
          },
          "balance_transaction"=> "txn_15F7NRBUofbCWxo13b34o8Ur",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_5PxIjCIAH2Z2ta",
          "invoice"=> "in_15F7NRBUofbCWxo1orerXZj3",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {},
          "statement_descriptor"=> "MyFlix monthly",
          "fraud_details"=> {},
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_15F7NRBUofbCWxo1CHexVa78/refunds",
            "data"=> []
          },
          "statement_description"=> "MyFlix monthly"
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_5PxIH4lTvHJxQd",
      "api_version"=> "2014-11-05"
    }
  end
  
  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end
  
  it "creates the payment associated with the user", :vcr do
    darren = Fabricate(:user, customer_token: "cus_5PxIjCIAH2Z2ta")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(darren)
  end
  
  it "creates the payment with the amount", :vcr do
    darren = Fabricate(:user, customer_token: "cus_5PxIjCIAH2Z2ta")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end
  
  it "creates the payment with reference_id", :vcr do
    darren = Fabricate(:user, customer_token: "cus_5PxIjCIAH2Z2ta")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_15F7NRBUofbCWxo1CHexVa78")
  end
end