class PricePeriodsController < ApplicationController
  before_action :set_room,            only: [:index, :new, :create]
  before_action :set_price_period,    only: [:edit, :update, :destroy]

  def index; end

  def new
    @price_period = PricePeriod.new(room: @room)
  end

  def create
    @price_period = PricePeriod.new(price_period_params)
    @price_period.room = @room
    if @price_period.save
      flash[:notice] = 'Preço por período cadastrado com sucesso'
      redirect_to price_periods_path(@room)
    else
      flash.now[:alert] = 'Preço por período não cadastrado'
      render :new, status: 422
    end
  end

  def edit; end

  def update
    if @price_period.update(price_period_params)
      flash[:notice] = 'Preço por período atualizado com sucesso'
      redirect_to price_periods_path(@price_period.room)
    else
      flash.now[:alert] = 'Preço por período não atualizado'
      render :edit, status: 422
    end
  end

  def destroy
    @price_period.destroy
    flash[:notice] = 'Preço por período apagado com sucesso'
    redirect_to price_periods_path(@price_period.room)
  end

  private

  def price_period_params
    params.require(:price_period).permit(:start_date, :end_date, :value)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_price_period
    @price_period = PricePeriod.find(params[:id])
    if @price_period.room.inn.user != current_user
      redirect_to my_inn_path
    end
  end
end