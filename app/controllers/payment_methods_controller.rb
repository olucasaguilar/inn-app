class PaymentMethodsController < ApplicationController
  before_action :block_guests
  before_action :force_inn_creation, only: [:new, :edit]
  before_action :set_payment_method, only: [:edit, :update, :destroy]
  
  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    @payment_method.additional_information = current_user.inn.additional_information

    if @payment_method.save
      redirect_to my_inn_path, notice: 'Forma de pagamento adicionada com sucesso'
    else
      flash.now[:alert] = 'Forma de pagamento não adicionada'
      render :new, status: 422
    end
  end

  def edit
    user_related_to_this_payment_method = @payment_method.additional_information.inn.user
    this_payment_method_belongs_to_current_user = user_related_to_this_payment_method == current_user
    unless this_payment_method_belongs_to_current_user
      redirect_to my_inn_path
    end
  end

  def update
    if @payment_method.update(payment_method_params)
      redirect_to my_inn_path, notice: 'Forma de pagamento atualizada com sucesso'
    else
      flash.now[:alert] = 'Forma de pagamento não atualizada'
      render :edit, status: 422
    end
  end

  def destroy
    if @payment_method.destroy
      redirect_to my_inn_path, notice: 'Forma de pagamento excluída com sucesso'
    else
      redirect_to my_inn_path, notice: 'Erro ao excluir forma de pagamento'
    end
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name)
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end
end