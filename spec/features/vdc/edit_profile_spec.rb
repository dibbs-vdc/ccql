require 'rails_helper'

RSpec.describe "Edit Profile page", type: feature do

  context 'Logged in user' do
    let!(:user) { create(:approved_user) }
    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as user
      visit "/dashboard/profiles/#{user.email.gsub('.com', '-dot-com')}/edit"
    end

    scenario 'Cannot view or edit' do
      expect(page).to_not have_content('How will you use the vdc?')
      expect(page).to_not have_content('Intended use')
      expect(page).to_not have_content('How long is your intended participation in the vdc?')
    end

    scenario 'Can edit profile page' do
      expect(page).to have_field('First name')
      expect(page).to have_field('Last name')
      expect(page).to have_field('Organization or Institution')
      expect(page).to have_field('Other organization or institution')
      expect(page).to have_field('Department')
      expect(page).to have_content('Position')
      expect(page).to have_field('Discipline')
      expect(page).to have_field('Orcid')
      expect(page).to have_field('Address')
      expect(page).to have_field('Email')
      expect(page).to have_field('Website')
      expect(page).to have_field('URL')
      expect(page).to have_content('Additional sites')
      expect(page).to have_field('Open Science Framework')
      expect(page).to have_field('ResearchGate')
      expect(page).to have_field('LinkedIn')
      expect(page).to have_field('VIVO')
      expect(page).to have_field('Institutional Repository')
      expect(page).to have_field('Other:')
      expect(page).to have_button('Update')
    end
  end
end
