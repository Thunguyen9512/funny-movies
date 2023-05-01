require 'rails_helper'

describe 'Share movie', type: :system do
  before do
    user = create(:user)
    sign_in(user)
    visit root_path
  end

  let(:movie_url) { 'https://www.youtube.com/watch?v=rvKmC9_1DG0&ab_channel=M%C3%A8o%C3%9AGuitar' }
  let(:title) { Faker::Movie.title }

  scenario 'share with valid url and title' do
    click_link 'Share a movie'
    fill_in 'Movie url', with: movie_url
    fill_in 'Title', with: title
    click_button 'Share'

    expect(page).to have_text 'Movies succesfull shared'
  end

  scenario 'share with invalid url' do
    click_link 'Share a movie'
    fill_in 'Movie url', with: nil
    fill_in 'Title', with: title
    click_button 'Share'

    expect(page).not_to have_text 'Movies succesfull shared'
  end

  scenario 'share with invalid title' do
    click_link 'Share a movie'
    fill_in 'Movie url', with: movie_url
    fill_in 'Title', with: nil
    click_button 'Share'

    expect(page).not_to have_text 'Movies succesfull shared'
  end
end