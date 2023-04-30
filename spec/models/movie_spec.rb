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
end
