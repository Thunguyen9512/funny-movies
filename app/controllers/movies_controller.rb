class MoviesController < ApplicationController

  include Pagy::Backend

  before_action :set_movie, except: :index

  def index
    @pagy, @movies = pagy(Movie.all.order(created_at: :desc))
  end

  def update
    return unless @movie.shared_by?(current_user)

    if @movie.update(movie_params)
      flash[:notice] = 'Movies succesfull update'
    else
      flash[:error] = 'Something wrong, please try again'
    end
    redirect_to root_path
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
    @movie = Movie.find_by(id: params[:id])
  end

  def movie_params
    params[:movie].permit(:title, :movie_url, :description)
  end
end
