class InnAdditionalsController < ApplicationController
  before_action :set_inn_additional, only: [:edit, :update]

  def edit; end

  def update
    if @inn_additional.update(inn_additional_params)
      redirect_to my_inn_path, notice: 'Informações adicionais atualizadas com sucesso'
    else
      flash.now[:alert] = 'Informações adicionais não atualizadas'
      render :edit, status: 422
    end
  end

  private

  def inn_additional_params
    params.require(:inn_additional).permit(:description, :policies, :check_in, :check_out, :pets)
  end

  def set_inn_additional
    @inn_additional = current_user.inn.inn_additional
  end
end