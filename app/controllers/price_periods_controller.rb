class PricePeriodsController < ApplicationController
  before_action :set_room, only: [:index, :new, :create]

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

  private

  def price_period_params
    params.require(:price_period).permit(:start_date, :end_date, :value)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end
end