require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Create a Project', js: true, type: feature, chrome: true do
  context 'a logged in user' do
    let!(:user) { create(:admin_user, display_name: 'George Sand', password: 'testing123') }
    let!(:depositor) { Vdc::UserToPersonSyncService.new({user: user}).create_person_from_user(user) }

    before do
      admin_set = Hyrax::CollectionType.find_or_create_admin_set_type
      AdminSet.find_or_create_default_admin_set_id
      depositor
      login_as user
    end

    scenario do
      user_collection_type = Hyrax::CollectionType.find_or_create_default_collection_type

      visit "/dashboard/collections/new?locale=en&collection_type_id=#{user_collection_type.id}"

      expect(find('#collection_title_progress')[:class]).to eq "incomplete"
      fill_in('Title', with: 'Cloud Storage')
      find('body').click
      expect(find('#collection_title_progress')[:class]).to eq "complete"

      expect(find('#collection_depositor_progress')[:class]).to eq "complete"
      find('#collection_vdc_creator').select("")
      expect(find('#collection_depositor_progress')[:class]).to eq "incomplete"
      find('#collection_vdc_creator').select("admin@example.com")
      expect(find('#collection_depositor_progress')[:class]).to eq "complete"

      expect(find('#collection_size_progress')[:class]).to eq "incomplete"
      find('#collection_collection_size').select("<1 GB")
      expect(find('#collection_size_progress')[:class]).to eq "complete"

      click_button "Create Project"
      expect(page).to have_content "Project was successfully created."
    end
  end
end
