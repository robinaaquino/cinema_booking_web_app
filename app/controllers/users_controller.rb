class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
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
