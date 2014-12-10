require 'spec_helper'

feature 'new user registration', { js: true, vcr: true } do
  background do
    visit register_path
  end
  
  scenario "with valid user info and valid credit card" do
    fill_in_valid_user_info
    fill_in_valid_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content("You have successfully registered")
  end
  
  scenario "with valid user info and invalid credit card" do
    fill_in_valid_user_info
    fill_in_invalid_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end
  
  scenario "with valid user info and declined credit card" do
    fill_in_valid_user_info
    fill_in_declined_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined.")
  end
  
  scenario "with invalid user info and valid credit card" do
    fill_in_invalid_user_info
    fill_in_valid_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content("Please correct the fields below. Your card has not been charged.")
  end
  
  scenario "with invalid user info and invalid credit card" do
    fill_in_invalid_user_info
    fill_in_invalid_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content("Please correct the fields below. Your card has not been charged.")
  end
  
  scenario "with invalid user info and declined credit card" do
    fill_in_invalid_user_info
    fill_in_declined_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content("Please correct the fields below. Your card has not been charged.")
  end
  
  def fill_in_valid_user_info
    fill_in "Email Address", with: "alice@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Alice Smith"
  end
  
  def fill_in_invalid_user_info
    fill_in "Email Address", with: "alice@example.com"
    fill_in "Password", with: "password"
  end
  
  def fill_in_valid_credit_card_info
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "11 - November", from: "date_month"
    select "2016", from: "date_year"
  end
  
  def fill_in_invalid_credit_card_info
    fill_in "Credit Card Number", with: "0"
    fill_in "Security Code", with: "123"
    select "11 - November", from: "date_month"
    select "2016", from: "date_year"
  end
  
  def fill_in_declined_credit_card_info
    fill_in "Credit Card Number", with: "4000000000000002"
    fill_in "Security Code", with: "123"
    select "11 - November", from: "date_month"
    select "2016", from: "date_year"
  end
  
end