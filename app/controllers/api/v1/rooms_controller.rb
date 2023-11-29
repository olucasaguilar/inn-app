class Api::V1::RoomsController < Api::V1::ApiController
  def index
    inn = Inn.find(params[:inn_id])
    
    rooms = inn.rooms.active
    rooms = rooms.as_json(except: [:created_at, :updated_at])

    render status: 200, json: rooms
  end

  def availability
    room = Room.find(params[:id])
    check_in = params[:check_in]
    check_out = params[:check_out]
    guests = params[:guests]
                  
    reservation = Reservation.new(check_in: check_in, check_out: check_out, guests: guests, room: room)
    reservation.valid? ? available = true : available = false
    
    available ? value = reservation.total_value : value = nil
    
    if reservation.valid?
      response = { available: available, value: value }
    else
      response = { available: available, errors: reservation.errors.full_messages }
    end

    render status: 200, json: response
  end
end