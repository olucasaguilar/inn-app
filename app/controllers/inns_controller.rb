class InnsController < ApplicationController
  before_action :set_my_inn,                only: [:my_inn, :edit, :update, :change_status]
  before_action :redirect_inn_keeper_out,   only: [:new]
  before_action :block_guests,              except: [:show, :city, :search]
  before_action :authenticate_user!,        except: [:show, :city, :search]
  before_action :force_inn_creation,        except: [:new, :create]

  def new
    @inn = Inn.new(address: Address.new)
    @inn_additional = InnAdditional.new(inn: @inn)
  end

  def show
    @inn = Inn.find(params[:id])
    return redirect_to root_path if @inn.inactive?
    @reviews = @inn.reviews.last(3)
  end

  def create
    @inn = Inn.new(inn_params)
    @inn.address = Address.new(address_params)
    @inn.user_id = current_user.id
    @inn_additional = InnAdditional.new(inn_additional_params)
    @inn_additional.inn = @inn
    
    both_valid = true
    both_valid = false if @inn.invalid?
    both_valid = false if @inn_additional.invalid?

    if both_valid
      @inn.save
      @inn_additional.save
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

  def city
    @city = params[:format]
    @inns = Inn.active.where(address: Address.where(city: @city)).order(name: :asc)    
  end

  def search
    @query = params[:query]
    @inns  = Inn.active.where(address: Address.where("city LIKE ?", "%#{@query}%"))
    @inns += Inn.active.where(address: Address.where("neighborhood LIKE ?", "%#{@query}%"))
    @inns += Inn.active.where("name LIKE ?", "%#{@query}%")
    @inns  = @inns.sort_by { |inn| inn.name }

    @inns.uniq!
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

  def inn_additional_params
    params.require(:inn_additional).permit(:check_in, :check_out)
  end
end