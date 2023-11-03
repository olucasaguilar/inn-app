class PaymentMethodsController < ApplicationController
  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    @payment_method.additional_information = Inn.last.additional_information

    if @payment_method.save
      redirect_to my_inn_path, notice: 'Forma de pagamento adicionada com sucesso'
    else
      flash.now[:alert] = 'Forma de pagamento não adicionada'
      render :new
    end
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name)
  end
end