# Generated via
#  `rails generate hyrax:work Vdc::Resource`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.describe 'Create a Vdc::Resource', js: true, type: feature, chrome: true do
  context 'a logged in user' do
    let!(:user) { create(:admin_user, password: 'testing123') }

    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as user
    end

    scenario do
      visit '/concern/vdc/resources/new'
      # If you generate more than one work uncomment these lines
      # choose "payload_concern", option: "Vdc::Resource"
      # click_button "Create work"

      expect(page).to have_content "Add New Resource"
      expect(page).not_to have_content "Embargo"
      expect(page).not_to have_content "Lease"
    end
  end
end
