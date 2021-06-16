require 'rails_helper'

RSpec.describe "Profile buttons and routes", type: feature do

  context 'Logged in user on Profile page' do

    let!(:user) { create(:approved_user) }

    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as user
      visit '/dashboard/profiles/approved@example-dot-com'
    end

    scenario 'Can view Share Your Work, Edit Profile, and Dashboard links' do
      expect(page).to have_link('Share Your Work')
      expect(page).to have_link('Edit Profile')
      expect(page).to have_link('Dashboard')
    end

    scenario 'Can view the VDC logo' do
      expect(page).to have_xpath("//img[contains(@src,'/assets/VDC-Logo-2153fa5590ecd60f2a193b840ac8b5922b26187de8e2d9710589966c833f1a80.png')]")
    end

    scenario 'Can click Share Your Work and be routed to correct page' do
      click_link('Share Your Work')
      expect(page.current_path).to eq '/dashboard/my/works'
    end

    scenario 'Can click Edit Profile and be routed to correct page' do
      click_link('Edit Profile')
      expect(page.current_path).to eq '/dashboard/profiles/approved@example-dot-com/edit'
    end

    scenario 'Can click Dashboard and be routed to correct page' do
      first('#profile-dashboard-link').click_link('Dashboard')
      expect(page.current_path).to eq '/dashboard'
    end

    scenario 'Can click VDC logo and be routed to Homepage' do
      find(:xpath, "//a/img[@alt='Vdc logo']/..").click
      expect(page.current_path).to eq '/'
    end
  end
end
