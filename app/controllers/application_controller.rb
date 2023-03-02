class ApplicationController < ActionController::Base
  include SessionsHelper

  private
    def admin_user
      unless is_admin?
        flash[:danger] = "Unauthorized user"
        redirect_to root_path
      end
    end
end
