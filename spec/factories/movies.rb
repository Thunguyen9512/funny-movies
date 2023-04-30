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
FactoryBot.define do
  factory :movie do
    movie_url { 'https://www.youtube.com/watch?v=2L32VYBW6C4&list=RDKXy_q2vOzjg&index=15&ab_channel=tas' }
    title { Faker::Movie.title }
    user
  end
end
