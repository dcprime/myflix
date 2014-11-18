require 'spec_helper'

feature 'adding and accessing video' do
  
  scenario "admin adds a new video" do
    darren = Fabricate(:admin)
    alice = Fabricate(:user)
    scifi = Fabricate(:category, name: "Sci-Fi")
    
    sign_in(darren)
    visit new_admin_video_path
    
    fill_in "Title", with: "Babylon 5 - In The Beginning"
    select "Sci-Fi", from: "Category"
    fill_in "Description", with: "Londo Mollari tells the story of the Earth-Minbari war in this prequel to the popular Babylon 5 TV series."
    attach_file "Large cover", "spec/support/uploads/star_wars_large.jpg"
    attach_file "Small cover", "spec/support/uploads/star_wars_small.jpg"
    fill_in "Video url", with: "http://www.freevideos.com/b5_itb.mp4"
    click_button "Add Video"
    
    sign_out
    sign_in
    visit home_path
    expect(page).to have_css("img[src*='star_wars_small.jpg']")
    find("a[href='/videos/1']").click
    expect(page).to have_css("img[src*='star_wars_large.jpg']")
    expect(page).to have_selector("a[href='http://www.freevideos.com/b5_itb.mp4']")
  end
end