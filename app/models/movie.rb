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
class Movie < ApplicationRecord
  belongs_to :user
  has_many :reacts, dependent: :destroy

  validates :movie_url, presence: true

  def liked_by?(liked_user)
    return true if reacts.where(user: liked_user, react_type: 'like').present?

    false
  end

  def dislike_by?(liked_user)
    return true if reacts.where(user: liked_user, react_type: 'dislike').present?

    false
  end

  def url_embed_url
    movie_url.gsub('watch?v=', 'embed/').split('&').first
  end
end
