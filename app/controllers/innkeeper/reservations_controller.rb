class Innkeeper::ReservationsController < ApplicationController
  def index
    @reservations = current_user.inn.rooms.map { |room| room.reservations.pending }.flatten
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

  def canceled
    @reservation = Reservation.find(params[:id])
    
    return redirect_to root_path unless @reservation.room.inn == current_user.inn

    if @reservation.cancel_innkeeper
      flash[:alert] = 'Reserva cancelada com sucesso!'
    else
      flash[:alert] = 'Reserva só pode ser cancelada após 2 dias do check-in'
      return redirect_to innkeeper_reservation_path(@reservation)
    end
    
    redirect_to innkeeper_reservations_path
  end

  def active_reservations
    @reservations = current_user.inn.rooms.map { |room| room.reservations.active }.flatten
  end
end