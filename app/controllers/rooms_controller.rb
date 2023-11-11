class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :change_status]

  def show; end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.inn = current_user.inn

    if @room.save
      flash[:notice] = "#{@room.name} adicionado com sucesso"
      redirect_to room_path(@room)
    else
      flash.now[:alert] = 'Não foi possível adicionar o quarto'
      render :new, status: 422
    end
  end

  def edit; end

  def update
    if @room.update(room_params)
      flash[:notice] = "#{@room.name} atualizado com sucesso"
      redirect_to room_path(@room)
    else
      flash.now[:alert] = 'Não foi possível atualizar o quarto'
      render :edit, status: 422
    end
  end

  def change_status
    @room.status? ? @room.status = false : @room.status = true
    @room.save
    flash[:notice] = 'Disponibilidade atualizada com sucesso'
    redirect_to room_path(@room)
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :dimension, :max_occupancy, :value,
                                  :bathroom, :balcony, :air_conditioning, :tv, :wardrobe, :safe, :accessible)
  end

  def set_room
    @room = Room.find(params[:id] || params[:room_id])
    if @room.inn.user != current_user
      redirect_to my_inn_path
    end
  end
end