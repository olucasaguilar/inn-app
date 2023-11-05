class InnsController < ApplicationController
  before_action :set_my_inn,                only: [:my_inn, :edit, :update, :change_status]
  before_action :redirect_inn_keeper_out,   only: [:new]
  before_action :block_guests
  before_action :force_inn_creation,        only: [:edit, :my_inn]

  def new
    @inn = Inn.new(address: Address.new)
    @additional_information = AdditionalInformation.new(inn: @inn)
  end

  def create
    @inn = Inn.new(inn_params)
    @inn.address = Address.new(address_params)
    @inn.user_id = current_user.id
    @additional_information = AdditionalInformation.new(additional_information_params)
    @additional_information.inn = @inn
    
    both_valid = true
    both_valid = false if @inn.invalid?
    both_valid = false if @additional_information.invalid?

    if both_valid
      @inn.save
      @additional_information.save
      redirect_to my_inn_path, notice: 'Pousada cadastrada com sucesso'
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

  def change_status
    @inn.active? ? @inn.inactive! : @inn.active!
    flash[:notice] = 'Status atualizado com sucesso'
    redirect_to my_inn_path
  end

  private

  def set_my_inn
    @inn = current_user.inn
  end

  def inn_params
    params.require(:inn).permit(:name, :social_name, :cnpj, :phone, :email)
  end

  def address_params
    params.require(:address).permit(:street, :neighborhood, :state, :city, :zip_code)
  end

  def additional_information_params
    params.require(:additional_information).permit(:check_in, :check_out)
  end
end