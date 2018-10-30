require 'rails_helper'

RSpec.feature 'User login' do
  let(:approved_user)     { create(:approved_user, email: 'approved@example.com', password: 'testing123') }
  let(:not_approved_user) { create(:user, email: 'not_approved@example.com', password: 'testing123') }

  scenario 'with approved user' do
    visit new_user_session_path

    page.fill_in 'Email', with: approved_user.email
    page.fill_in 'Password', with: 'testing123'

    click_button 'Log in'

    expect(page.current_path).to eq '/dashboard/profiles/approved@example-dot-com'
  end 

  scenario 'with unapproved user' do
    visit new_user_session_path

    page.fill_in 'Email', with: not_approved_user.email
    page.fill_in 'Password', with: 'testing123'

    click_button 'Log in'

    expect(page.current_path).to eq '/users/sign_in'
    expect(page).to have_content(I18n.t('devise.failure.not_approved'))
  end
end 