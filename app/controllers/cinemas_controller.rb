class CinemasController < ApplicationController
  before_action :set_cinema, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:create, :edit, :update, :destroy]

  def index
    @cinemas = Cinema.all
    @is_admin = is_admin?
    @cinema_count = Cinema.count
    @cinema_info = {}
    @cinemas.each do |cinema|
      @cinema_info[cinema.id] = Seat.where(cinema_id: cinema.id).count
    end
  end

  def show
    @is_admin = is_admin?
    @movies = @cinema.movies
    @seat_count = Seat.where(cinema_id: @cinema.id).count
  end

  def new
    @cinema = Cinema.new
  end

  def create
    @cinema = current_user.cinemas.build(cinema_parameters)
    if @cinema.save
      flash.now[:success] = "Successfully created a cinema"
      redirect_to @cinema
    else
      flash.now[:danger] = "Unable to create cinema"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @cinema.update(cinema_parameters)
      flash.now[:success] = "Successfully updated a cinema"
      redirect_to @cinema
    else
      flash.now[:danger] = "Unable to update cinema"
      render 'edit'
    end
  end

  def destroy
    if @cinema.destroy
      flash.now[:success] = "Successfully deleted a cinema"
      redirect_to cinemas_url
    else
      flash.now[:danger] = "Unable to delete cinema"
      render 'index'
    end
  end

  private
    def set_cinema
      @cinema = Cinema.find(params[:id])
    end

    def cinema_parameters
      params.require(:cinema).permit(:name)
    end
end
