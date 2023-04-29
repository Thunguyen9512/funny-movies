class CreateReacts < ActiveRecord::Migration[5.2]
  def change
    create_table :reacts do |t|
      t.integer :user_id
      t.integer :movie_id
      t.integer :react_type
      
      t.timestamps
    end
  end
end
