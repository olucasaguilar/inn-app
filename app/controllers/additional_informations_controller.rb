class AdditionalInformationsController < ApplicationController
  before_action :block_guests
  before_action :force_inn_creation, only: [:edit]
  before_action :set_additional_information, only: [:edit, :update]

  def edit; end

  def update
    if @additional_information.update(additional_information_params)
      redirect_to my_inn_path, notice: 'Informações adicionais atualizadas com sucesso'
    else
      flash.now[:alert] = 'Informações adicionais não atualizadas'
      render :edit, status: 422
    end
  end

  private

  def additional_information_params
    params.require(:additional_information).permit(:description, :policies, :check_in, :check_out, :pets)
  end

  def set_additional_information
    @additional_information = current_user.inn.additional_information
  end
end