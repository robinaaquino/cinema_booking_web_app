class SeatsController < ApplicationController
  before_action :set_seat, only: [:show, :edit, :update, :destroy]

  def index
    @seats = Seat.all
  end

  def new
    @seat = Seat.new
    @seats = Seat.where(user_id: current_user, cinema_id: params[:cinema_id])
  end

  def show
    @movie = Movie.where(cinema_id: @seat.cinema_id)
  end

  def create
    @seat = current_user.seats.build(seat_parameters)
    @exists = Seat.where(cinema_id: @seat.cinema_id, timeslot: @seat.timeslot, seat_number: @seat.seat_number).first

    if @exists.nil?
      if @seat.save
        flash.now[:success] = "Successfully created a seat"
        redirect_to @seat
      else
        flash[:danger] = "Unable to create seat"
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
      flash.now[:success] = "Successfully deleted a seat"
      redirect_to seats_url
    else
      flash.now[:danger] = "Unable to delete seat"
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
