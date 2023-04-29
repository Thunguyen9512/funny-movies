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
  pending "add some examples to (or delete) #{__FILE__}"
end
