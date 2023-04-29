class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :movies_url
      t.string :title
      t.text :description
      t.integer :like_count, default: 0
      t.integer :dislike_count, default: 0
      t.integer :user_id

      t.timestamps
    end
  end
end
