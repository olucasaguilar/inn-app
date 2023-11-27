class Innkeeper::ReservationsController < ApplicationController
  def index
    @reservations = current_user.inn.rooms.map { |room| room.reservations }.flatten
  end

  def show
    @reservation = Reservation.find(params[:id])    
  end

  def active
    @reservation = Reservation.find(params[:id])  

    return redirect_to root_path unless @reservation.room.inn == current_user.inn

    if @reservation.active
      flash[:alert] = 'Check-in realizado com sucesso!'    
    else
      flash[:alert] = 'Check-in não pode ser realizado devido a data não ter chegado ainda.'
    end

    redirect_to innkeeper_reservation_path(@reservation)
  end
end