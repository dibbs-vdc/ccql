# Generated via
#  `rails generate hyrax:work Vdc::Resource`
require 'rails_helper'

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Vdc::Resource', js: false do
  context 'a logged in user' do
    let!(:user) { create(:admin_user, password: 'testing123') }

    before do
      login_as user
      visit '/admin/admin_sets/new'
      page.fill_in 'Title', with: 'Default Admin Set'
      page.fill_in 'Abstract or Summary', with: 'WHAT is your quest?'
      click_button 'Save'
    end

    scenario do
      visit '/dashboard/my/works'
      page.click_link('Add new work')

      # If you generate more than one work uncomment these lines
      # choose "payload_concern", option: "Vdc::Resource"
      # click_button "Create work"

      expect(page).to have_content "Add New Resource"
    end
  end
end
