class PricePeriodsController < ApplicationController
  def index
    @room = Room.find(params[:room_id])
  end
end