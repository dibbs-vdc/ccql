require 'rails_helper'
include Warden::Test::Helpers


RSpec.describe 'User login', :clean, type: feature do
  let(:approved_user)     { create(:approved_user, password: 'testing123') }
  let(:not_approved_user) { create(:user, password: 'testing123') }

  scenario 'with approved user' do
    visit new_user_session_path

    click_button 'Manual Sign In'

    page.fill_in 'Email', with: approved_user.email
    page.fill_in 'Password', with: 'testing123'

    within 'div#direct_login' do
      click_button 'Sign in'
    end

    expect(page.current_path).to eq "/dashboard/profiles/#{approved_user.email.gsub('.com', '-dot-com')}"
  end

  scenario 'with unapproved user' do
    visit new_user_session_path

    click_button 'Manual Sign In'

    page.fill_in 'Email', with: not_approved_user.email
    page.fill_in 'Password', with: 'testing123'

    within 'div#direct_login' do
      click_button 'Sign in'
    end

    expect(page.current_path).to eq '/users/sign_in'
    expect(page).to have_content(I18n.t('devise.failure.not_approved'))
  end
end
