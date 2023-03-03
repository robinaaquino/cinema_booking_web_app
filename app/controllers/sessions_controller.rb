class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      if is_admin?
        redirect_to users_url
      else
        redirect_to user
      end

    else
      flash.now[:danger] = 'Unable to login'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
