# Generated via
#  `rails generate hyrax:work Vdc::Resource`
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Create a Vdc::Resource with cloud storage', js: true, type: feature, chrome: true do
  context 'a logged in user' do
    let!(:user) { create(:admin_user, display_name: 'George Sand', password: 'testing123') }
    let!(:depositor) { Vdc::UserToPersonSyncService.new({user: user}).create_person_from_user(user) }
    let!(:collection) { FactoryBot.create(:collection, title: ['Atmospheric Data']) }

    before do
      AdminSet.find_or_create_default_admin_set_id
      depositor
      login_as user
    end

    scenario do
      visit '/concern/vdc/resources/new'

      fill_in('Title', with: 'Cloud Storage')
      find('#vdc_resource_vdc_creator').select("admin@example.com")

      # All required metadata should be complete
      expect(find('#required-metadata')[:class]).to eq "complete"

      # Check that customized form progress UI is in place
      expect(find('#resource_title')[:class]).to eq "complete"
      expect(find('#resource_vdc_creator')[:class]).to eq "complete"
      expect(find('#resource_genre')[:class]).to eq "complete"
      expect(page).to have_content "Add project under relationships tab"
      expect(page).to have_content "Check deposit agreement"

      click_link "Files" # switch tab
      within('span#addfiles') do
        attach_file("files[]", File.join(fixture_path, 'dummy.pdf'), visible: false)
      end
      # click_button "Add cloud files..."

      click_link "Relationships" # switch tab

      # If you generate more than one work uncomment these lines
      # choose "payload_concern", option: "Vdc::Resource"
      # click_button "Create work"

      expect(page).to have_content "Add New Resource"
      expect(page).not_to have_content "Embargo"
      expect(page).not_to have_content "Lease"
    end
  end
end
