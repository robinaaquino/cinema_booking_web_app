class UsersController < ApplicationController
  before_action :admin_user, only: [:index]

  def index
    @users = User.all
    @all_seats = Seat.includes(:user, :cinema)
    @seats = {}
    @users.each do |user|
      @seats[user.id] = []
      @all_seats.each do |seat|
        if seat.user_id == user.id
          @seats[user.id].push(seat)
        end
      end
    end

    @movies = Movie.all
    @movies_info = {}
    @movies.each do |movie|
      @movies_info[movie.cinema_id] = movie.name
    end
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
    @user = User.find(params[:id])
    @all_seats = Seat.includes(:user, :cinema)
    @seats = []
    @all_seats.each do |seat|
      if seat.user_id == @user.id
        @seats.push(seat)
      end
    end

    @movies = {}
    @seats.each do |seat|
      @movies[seat.cinema_id] = Movie.find_by(cinema_id: seat.cinema_id).name
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash.now[:success] = "Successfully created an account"
      redirect_to @user
    else
      flash.now[:danger] = "Unable to sign up"
      render 'new'
    end
  end

  def edit
  end

  private
    def user_params
      params.require(:user).permit(:full_name, :email, :number, :password)
    end
end
