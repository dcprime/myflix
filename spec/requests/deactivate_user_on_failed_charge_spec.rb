require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id"=> "evt_15FSj7BUofbCWxo1f4tChuMU",
      "created"=> 1419956409,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_15FSj7BUofbCWxo14VUODwKw",
          "object"=> "charge",
          "created"=> 1419956409,
          "livemode"=> false,
          "paid"=> false,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "captured"=> false,
          "card"=> {
            "id"=> "card_15FShtBUofbCWxo1iPrGhCXe",
            "object"=> "card",
            "last4"=> "0341",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 12,
            "exp_year"=> 2016,
            "fingerprint"=> "chHqj745Rtcjn2pe",
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
            "customer"=> "cus_5PzFaAIrr2QVb6"
          },
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_5PzFaAIrr2QVb6",
          "invoice"=> nil,
          "description"=> "payment to fail",
          "dispute"=> nil,
          "metadata"=> {},
          "statement_descriptor"=> nil,
          "fraud_details"=> {},
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_15FSj7BUofbCWxo14VUODwKw/refunds",
            "data"=> []
          },
          "statement_description"=> nil
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_5QJL2nlAbq9DoY",
      "api_version"=> "2014-11-05"
    }
  end
  
  it "deactivates the user with the web hook data from stripe for a failed charge", :vcr do
    darren = Fabricate(:user, customer_token: "cus_5PzFaAIrr2QVb6")
    post "/stripe_events", event_data
    expect(darren.reload).not_to be_active
  end
end