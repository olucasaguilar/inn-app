class GuestUsersController < ApplicationController
  before_action :force_guest_add_personal_info, except: [:edit, :update]
  before_action :block_guests, except: [:edit, :update]
  
  def edit; end

  def update
    if current_user.guest_user.update(guest_user_params)
      flash[:notice] = 'Boas Vindas! Você realizou seu registro com sucesso.'

      if session[:reservation].present?
        room = Room.find(session[:reservation]['room_id'])
        return redirect_to confirm_inn_room_reservations_path(room.inn, room)
      end

      redirect_to root_path
    else
      render :edit, status: 422
    end
  end

  private

  def guest_user_params
    params.require(:guest_user).permit(:cpf)
  end
end