class ApplicationController < ActionController::Base
  include SessionsHelper

  private
    def admin_user
      unless is_admin?
        flash[:danger] = "Unauthorized user"
        redirect_to root_path
      end
    end

    def logged_in_user
      unless logged_in?
          flash[:danger] = "Please log in."
          redirect_to login_url
      end
  end
end
