class UsersController < ApplicationController
  before_action :admin_user, only: [:index, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy]

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
      flash.now[:success] = "Successfully created account"
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
