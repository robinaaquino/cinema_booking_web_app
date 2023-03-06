class SeatsController < ApplicationController
  before_action :set_seat, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:index]

  def index
    @seats = Seat.all
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
    @seat = Seat.new
    @seats = Seat.where(user_id: current_user, cinema_id: params[:cinema_id])
  end

  def show
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
    @movie = Movie.where(cinema_id: @seat.cinema_id).first
  end

  def create
    @seat = current_user.seats.build(seat_parameters)
    @exists = Seat.where(cinema_id: @seat.cinema_id, timeslot: @seat.timeslot, seat_number: @seat.seat_number).first

    if @exists.nil?
      if @seat.save
        flash[:success] = "Successfully booked a seat"
        redirect_to @seat
      else
        flash[:danger] = "Unable to book a seat"
        redirect_to cinemas_url
      end
    else
      flash[:danger] = "Seat occupied"
      redirect_to cinemas_url
    end
  end

  def edit
  end

  def update
    if @seat.update(seat_parameters)
      flash.now[:success] = "Successfully updated a seat"
      redirect_to @seat
    else
      flash.now[:danger] = "Unable to update seat"
      render 'edit'
    end
  end

  def destroy
    if @seat.destroy
      flash.now[:success] = "Successfully unbooked a seat"
      redirect_to seats_url
    else
      flash.now[:danger] = "Unable to unbook seat"
      render 'index'
    end
  end

  private
    def set_seat
      @seat = Seat.find(params[:id])
    end

    def seat_parameters
      params.require(:seat).permit(:timeslot, :seat_number, :cinema_id)
    end
end
