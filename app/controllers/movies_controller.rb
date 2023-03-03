class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:create, :edit, :update, :destroy]

  def index
    @movies = Movie.all
    @is_admin = is_admin?
    @movie_count = Movie.count
  end

  def show
    @is_admin = is_admin?
    @cinema = Cinema.find(@movie.cinema_id)
  end

  def new
    @movie = Movie.new
    @cinemas = Cinema.where.missing(:movies)
    if @cinemas.nil? || @cinemas.count == 0
      flash[:danger] = "No available cinemas"
      redirect_to cinemas_url
    end
  end

  def create
    @movie = current_user.movies.build(movie_parameters)
    if @movie.save
      flash.now[:success] = "Successfully created a movie"
      redirect_to movies_url
    else
      flash.now[:danger] = "Unable to create movie"
      render 'new'
    end
  end

  def edit
    @is_admin = is_admin?
    @cinemas = Cinema.where.missing(:movies)
  end

  def update
    if @movie.update(movie_parameters)
      flash.now[:success] = "Successfully updated a movie"
      redirect_to @movie
    else
      flash.now[:danger] = "Unable to update movie"
      render 'edit'
    end
  end

  def destroy
    if @movie.destroy
      flash.now[:success] = "Successfully deleted a movie"
      redirect_to movies_url
    else
      flash.now[:danger] = "Unable to delete movie"
      render 'index'
    end
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_parameters
      params.require(:movie).permit(:name, :cinema_id)
    end
end
