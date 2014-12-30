require 'spec_helper'

feature 'User signs in' do
  scenario "with valid email and password" do
    darren = Fabricate(:user)
    sign_in(darren)
    expect(page).to have_content(darren.full_name)
  end
  
  scenario "with deactivated account" do
    darren = Fabricate(:user, active: false)
    sign_in(darren)
    expect(page).not_to have_content(darren.full_name)
    expect(page).to have_content("Your account has been suspended. Please contact customer service.")
  end
end