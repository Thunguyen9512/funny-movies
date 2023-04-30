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

    context 'uniq react for movie and user' do
      let!(:react) { create(:react) }

      it 'it invalid to create react with same user and movie' do
        new_react = build(:react, movie: react.movie, user: react.user)

        expect(new_react).to_not be_valid
      end
    end
  end

  describe 'callbacks' do 
    describe 'recalculate like dislike count' do
      let(:movie) { create(:movie) }
      context 'new like dislike' do

        it 'new like' do
          previous_like_count = movie.like_count
          previous_dislike_count = movie.dislike_count
          create(:react, movie: movie, react_type: 'like')

          expect(movie.like_count).to eq previous_like_count + 1
          expect(movie.dislike_count).to eq previous_dislike_count
        end

        it 'new dislike' do
          previous_like_count = movie.like_count
          previous_dislike_count = movie.dislike_count
          create(:react, movie: movie, react_type: 'dislike')

          expect(movie.like_count).to eq previous_like_count
          expect(movie.dislike_count).to eq previous_dislike_count + 1
        end
      end

      context 'update like dislike' do
        let!(:react) { create(:react, movie: movie, react_type: 'like') }
        it 'toggle like dislike' do
          previous_like_count = movie.like_count
          previous_dislike_count = movie.dislike_count
          react.update(react_type: 'dislike')

          expect(movie.dislike_count).to eq previous_dislike_count + 1
          expect(movie.like_count).to eq previous_like_count - 1
        end
      end
    end
  end
end
