require 'rails_helper'

describe 'User signs up', type: :system do
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(min_length: 6) }

  before do
    visit new_user_registration_path
  end

  scenario 'with valid data' do
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Sign up'

    expect(page).to have_text "Welcome #{email}"
    expect(page).to have_link 'Sign out'
    expect(page).to have_link 'Share a movie'
  end

  scenario 'invalid when email already exists' do
    user = create :user

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Sign up'

    expect(page).to have_text 'Email has already been taken'
  end
end