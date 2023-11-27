class Innkeeper::ReservationsController < ApplicationController
  def index
    @reservations = current_user.inn.rooms.map { |room| room.reservations }.flatten
  end
end