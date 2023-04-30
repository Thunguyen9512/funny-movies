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
FactoryBot.define do
  factory :react do
    movie { Movie.first }
    user { User.first }
    react_type { 'like' }
  end
end
