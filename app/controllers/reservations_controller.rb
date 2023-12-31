class ReservationsController < ApplicationController
  before_action :authenticate_user!,    except: [:new, :validate]
  before_action :block_guests,          except: [:new, :validate, :create, :confirm, :index, :show, :canceled]

  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
  end

  def validate
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(set_reservation)
    @reservation.room = @room    
    if @reservation.valid?
      session[:reservation] = @reservation
      render :validate, status: 422
    else
      render :new, status: 422
    end
  end

  def confirm
    @reservation = Reservation.new(session[:reservation])
  end

  def create
    @reservation = Reservation.new(session[:reservation])
    @reservation.user = current_user
    if @reservation.save
      flash[:alert] = 'Reserva confirmada com sucesso!'
      redirect_to root_path
    else
      flash[:alert] = 'Não foi possível confirmar a reserva'
      redirect_to new_inn_room_reservation_path(@reservation.room.inn, @reservation.room)
    end
  end

  def index
    @reservations = current_user.reservations
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def canceled
    @reservation = Reservation.find(params[:id])
    
    return redirect_to root_path unless @reservation.user == current_user

    if @reservation.cancel
      flash[:alert] = 'Reserva cancelada com sucesso'
    else
      flash[:alert] = 'Não é possível cancelar uma reserva com menos de 7 dias antes do check-in'
    end
    
    redirect_to inn_room_reservation_path(@reservation.room.inn, @reservation.room, @reservation)
  end

  private

  def set_reservation
    params.require(:reservation).permit(:check_in, :check_out, :guests)
  end
end