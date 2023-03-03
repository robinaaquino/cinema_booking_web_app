class SeatsController < ApplicationController
  before_action :set_seat, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]

  def index
    @seats = Seat.all
  end

  def new
    @seat = Seat.new
    @seats = Seat.where(cinema_id: params[:cinema_id])
    @timeslot_choices = {_10am: 0, _2pm: 1, _6pm: 2, _10pm: 3}

    @seat_number_choices_10am = {seat_0: 0, seat_1: 1, seat_2: 2, seat_3: 3, seat_4: 4, seat_5: 5, seat_6: 6, seat_7: 7, seat_8: 8, seat_9: 9}
    @seat_number_choices_2pm = {seat_0: 0, seat_1: 1, seat_2: 2, seat_3: 3, seat_4: 4, seat_5: 5, seat_6: 6, seat_7: 7, seat_8: 8, seat_9: 9}
    @seat_number_choices_6pm = {seat_0: 0, seat_1: 1, seat_2: 2, seat_3: 3, seat_4: 4, seat_5: 5, seat_6: 6, seat_7: 7, seat_8: 8, seat_9: 9}
    @seat_number_choices_10pm = {seat_0: 0, seat_1: 1, seat_2: 2, seat_3: 3, seat_4: 4, seat_5: 5, seat_6: 6, seat_7: 7, seat_8: 8, seat_9: 9}

    @seats.each do |seat|
      puts @timeslot_seat_number
      if seat.timeslot == "_10am"
        @seat_number_choices_10am.delete(:"#{seat.seat_number}")
      elsif seat.timeslot == "_2pm"
        @seat_number_choices_2pm.delete(:"#{seat.seat_number}")
      elsif seat.timeslot == "_6pm"
        @seat_number_choices_6pm.delete(:"#{seat.seat_number}")
      else
        @seat_number_choices_10pm.delete(:"#{seat.seat_number}")
      end
    end
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
