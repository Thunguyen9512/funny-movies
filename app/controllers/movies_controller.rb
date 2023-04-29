class MoviesController < ApplicationController
  before_action :set_movie, except: :index

  def index
    @movies = Movie.all
  end

  def like
    return if @movie.liked_by?(current_user)

    react = React.find_or_initialize_by(user: current_user, movie: @movie)
    react.react_type = 'like'
    if react.save
      respond_to do |format|
        @movie.reload
        format.js { render :toggle_like_dislike }
      end
    else

    end
  end

  def dislike
    return if @movie.dislike_by?(current_user)

    react = React.find_or_initialize_by(user: current_user, movie: @movie)
    react.react_type = 'dislike'
    if react.save
      @movie.reload
      respond_to do |format|
        format.js { render :toggle_like_dislike }
      end
    else

    end
  end

  private

  def set_movie
    @movie = Movie.find_by(id: params[:movie_id])
  end
end
