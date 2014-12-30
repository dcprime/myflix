require 'spec_helper'

feature "Admin sees payments" do
  background do
    darren = Fabricate(:user, full_name: "Darren Conley", email: "darren@example.com")
    Fabricate(:payment, amount: 999, user: darren)
  end
  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Darren Conley")
    expect(page).to have_content("darren@example.com")
  end
  
  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Darren Conley")
    expect(page).not_to have_content("darren@example.com")
    expect(page).to have_content("You do not have permission to do that")
  end
end