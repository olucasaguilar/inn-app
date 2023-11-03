class PaymentMethodsController < ApplicationController
  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)

    if @payment_method.save
      redirect_to my_inn_path, notice: 'Forma de pagamento adicionada com sucesso'
    else
      flash.now[:alert] = 'Forma de pagamento não adicionada'
      render :new
    end
  end

  def edit
    @payment_method = PaymentMethod.find(params[:id])
  end

  def update
    @payment_method = PaymentMethod.find(params[:id])

    if @payment_method.update(payment_method_params)
      redirect_to my_inn_path, notice: 'Forma de pagamento atualizada com sucesso'
    else
      flash.now[:alert] = 'Forma de pagamento não atualizada'
      render :edit
    end
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name)
  end
end