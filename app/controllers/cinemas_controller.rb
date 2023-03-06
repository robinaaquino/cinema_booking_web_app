class CinemasController < ApplicationController
  before_action :set_cinema, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:create, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy, :timeslot]

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
    @cinema_seats = Seat.includes(:user, :cinema)
    @time_slot_values = {
      "_10am": "10 AM",
      "_2pm": "2 PM",
      "_6pm": "6 PM",
      "_10pm": "10 PM"
    }
    @seat_number_values = {
      "seat_0": "Seat 1",
      "seat_1": "Seat 2",
      "seat_2": "Seat 3",
      "seat_3": "Seat 4",
      "seat_4": "Seat 5",
      "seat_5": "Seat 6",
      "seat_6": "Seat 7",
      "seat_7": "Seat 8",
      "seat_8": "Seat 9",
      "seat_9": "Seat 10"
    }
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

  def timeslot
    @timeslot_value = params[:time_slot]
    @cinema_id = params[:cinema_id]
    @time_slot_values = {
      "_10am": "10 AM",
      "_2pm": "2 PM",
      "_6pm": "6 PM",
      "_10pm": "10 PM"
    }
    @seat_number_values = {
      "seat_0": "Seat 1",
      "seat_1": "Seat 2",
      "seat_2": "Seat 3",
      "seat_3": "Seat 4",
      "seat_4": "Seat 5",
      "seat_5": "Seat 6",
      "seat_6": "Seat 7",
      "seat_7": "Seat 8",
      "seat_8": "Seat 9",
      "seat_9": "Seat 10"
    }
    resulting_seats = Seat.left_outer_joins(:cinema).where(timeslot: @timeslot_value).where("cinemas.id": @cinema_id)
    @seats = {}
    resulting_seats.each do |seat|
      @seats[seat.seat_number] = seat
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
