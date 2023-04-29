class MoviesController < ApplicationController
  before_action :set_movie, except: :index

  def index
    @movies = Movie.all
  end

  def create
    movie = Movie.new(movie_params.merge(user: current_user))
    if movie.save
      flash[:notice] = 'Movies succesfull shared'
    else
      flash[:error] = 'Something wrong, please try again'
    end
    redirect_to root_path
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
      redirect_to root_path
    end
  end

  def dislike
    return if @movie.dislike_by?(current_user)

    react = React.find_or_initialize_by(user: current_user, movie: @movie)
    react.react_type = 'dislike'
    if react.save
      @movie.reload
      respond_to do |format|
        @movie.reload
        format.js { render :toggle_like_dislike }
      end
    else
      redirect_to root_path
    end
  end

  private

  def set_movie
    @movie = Movie.find_by(id: params[:movie_id])
  end

  def movie_params
    params[:movie].permit(:title, :movie_url)
  end
end
