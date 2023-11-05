class RoomsController < ApplicationController
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.inn = current_user.inn

    if @room.save
      flash[:notice] = "#{@room.name} adicionado com sucesso"
      redirect_to my_inn_path
    else
      flash.now[:alert] = 'Não foi possível adicionar o quarto'
      render :new, status: 422
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :dimension, :max_occupancy, :value,
                                  :bathroom, :balcony, :air_conditioning, :tv, :wardrobe, :safe, :accessible)
  end
end