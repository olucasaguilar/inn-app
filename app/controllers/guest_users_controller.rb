class GuestUsersController < ApplicationController
  before_action :force_guest_add_personal_info, except: [:edit, :update]
  before_action :block_guests, except: [:edit, :update]
  
  def edit; end

  def update
    if current_user.guest_user.update(guest_user_params)
      redirect_to root_path, notice: 'Boas Vindas! Você realizou seu registro com sucesso.'
    else
      render :edit, status: 422
    end
  end

  private

  def guest_user_params
    params.require(:guest_user).permit(:cpf)
  end
end