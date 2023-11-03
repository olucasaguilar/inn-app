class InnsController < ApplicationController
  before_action :set_my_inn, only: [:my_inn, :edit, :update]

  def new
    @inn = Inn.new(address: Address.new)
  end

  def create
    @inn = Inn.new(inn_params)
    @inn.address = Address.new(address_params)

    if @inn.save      
      redirect_to new_inn_path, notice: 'Pousada cadastrada com sucesso'
    else
      flash.now[:alert] = 'Pousada não cadastrada'
      render :new, status: 422
    end
  end

  def my_inn; end

  def edit; end

  def update
    @inn.assign_attributes(inn_params)
    @inn.address.assign_attributes(address_params)

    if @inn.save
      @inn.address.save
      redirect_to my_inn_path, notice: 'Pousada atualizada com sucesso'
    else
      flash.now[:alert] = 'Pousada não atualizada'
      render :edit, status: 422
    end
  end

  private

  def set_my_inn
    @inn = Inn.last
  end

  def inn_params
    params.require(:inn).permit(:name, :social_name, :cnpj, :phone, :email)
  end

  def address_params
    params.require(:address).permit(:street, :neighborhood, :state, :city, :zip_code)
  end
end