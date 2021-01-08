require 'rails_helper'

RSpec.describe "Share your work button", :clean, type: feature do

  context 'a user that is not logged in' do
    scenario "cannot view share your work button" do
      visit '/'
      expect(page).to_not have_content('Share Your Work')
    end
  end

  context 'A logged in user' do

    let!(:user) { create(:approved_user, password: 'testing123') }

    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as user
    end

    scenario "can see share your work button" do
      visit '/'
      expect(page).to have_content('Share Your Work')
    end

  end
end
