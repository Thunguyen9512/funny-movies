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
class React < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  enum react_type: {
    dislike: 0,
    like: 1
  }

  after_commit :recalculate_like_dislike_count

  validates :react_type, :movie_id, :user_id, presence: true
  validates :movie, uniqueness: { scope: :user_id }

  private

  def recalculate_like_dislike_count
    if transaction_include_any_action?([:create])
      movie.like_count += 1 if react_type == 'like'
      movie.dislike_count += 1 if react_type == 'dislike'
    else
      if react_type == 'like'
        movie.like_count += 1
        movie.dislike_count -= 1
      else
        movie.dislike_count += 1
        movie.like_count -= 1
      end
    end
    movie.save
  end
end
