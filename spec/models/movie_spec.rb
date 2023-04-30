# == Schema Information
#
# Table name: movies
#
#  id            :bigint           not null, primary key
#  description   :text
#  dislike_count :integer          default(0)
#  like_count    :integer          default(0)
#  movie_url     :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#
require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:reacts) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:movie_url) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'methods' do 
    let(:user) { create(:user) }
    let(:movie) { create(:movie, user: user) }

    it 'shared by' do
      expect(movie.shared_by?(user)).to be_truthy
    end

    it 'liked by' do
      create(:react, react_type: 'like', user: user, movie: movie)
      expect(movie.liked_by?(user)).to be_truthy
    end

    it 'dislike by' do
      create(:react, react_type: 'dislike', user: user, movie: movie)
      expect(movie.dislike_by?(user)).to be_truthy
    end

    it 'convert youtube url to embedded url' do
      movie = create(:movie, movie_url: 'https://www.youtube.com/watch?v=7UWOA9Afbxw&list=RDKXy_q2vOzjg&index=13&ab_channel=BinzDaPoet')

      expect(movie.movie_url_embed).to eq 'https://www.youtube.com/embed/7UWOA9Afbxw'
    end
  end
end
