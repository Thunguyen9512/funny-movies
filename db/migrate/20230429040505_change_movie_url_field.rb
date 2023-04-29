class ChangeMovieUrlField < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :movies_url, :movie_url
  end
end
