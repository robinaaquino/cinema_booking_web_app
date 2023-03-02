class CinemasController < ApplicationController

  def index
    @cinemas = Cinema.all
  end

end
