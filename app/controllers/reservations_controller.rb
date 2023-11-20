class ReservationsController < ApplicationController
  before_action :authenticate_user!,    except: [:new, :validate]
  before_action :block_guests,          except: [:new, :validate]

  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
  end

  def validate
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(set_reservation)
    @reservation.room = @room    
    if @reservation.valid?
      set_reservation_total_value(@reservation)
      render :validate, status: 422
    else
      render :new, status: 422
    end
  end

  private

  def set_reservation_total_value(reservation)
    total_days = (reservation.check_out - reservation.check_in).to_i
    @reservation_total_value = total_days * reservation.room.value
  end

  def set_reservation
    params.require(:reservation).permit(:check_in, :check_out, :guests)
  end
end