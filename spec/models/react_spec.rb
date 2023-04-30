# == Schema Information
#
# Table name: reacts
#
#  id         :bigint           not null, primary key
#  react_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  movie_id   :integer
#  user_id    :integer
#
require 'rails_helper'

RSpec.describe React, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:movie) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:react_type) }
  end

  describe 'callbacks' do 
    describe 'recalculate like dislike count' do

      before do
        create(:user)
        create(:movie)
      end

      context 'new like dislike' do
        let!(:user) { User.create(email: '123@gmail.com', password: '123456') }
        let!(:movie) { Movie.create(movie_url: 'test_url', user_id: user.id) }

        it 'new like' do
          previous_like_count = movie.like_count
          previous_dislike_count = movie.dislike_count
          React.create(
            movie: movie,
            user: User.first,
            react_type: 'like'
          )
          expect(movie.dislike_count).to eq previous_dislike_count
          expect(movie.like_count).to eq previous_like_count + 1
        end

        it 'new dislike' do
          previous_like_count = movie.like_count
          previous_dislike_count = movie.dislike_count
          React.create(
            movie: movie,
            user: User.first,
            react_type: 'dislike'
          )
          expect(movie.like_count).to eq previous_like_count
          expect(movie.dislike_count).to eq previous_dislike_count + 1
        end
      end

      context 'update like dislike' do
        let!(:user) { User.first }
        let!(:movie) { Movie.first }
        let!(:react) { React.create(user_id: user.id, movie_id: movie.id, react_type: 'like') }
        it 'toggle like dislike' do
          movie.reload
          previous_like_count = movie.like_count
          previous_dislike_count = movie.dislike_count
          react.update(
            react_type: 'dislike'
          )
          movie.reload
          expect(movie.dislike_count).to eq previous_dislike_count + 1
          expect(movie.like_count).to eq previous_like_count - 1
        end
      end
    end
  end
end
