class AdditionalInformationsController < ApplicationController
  def edit
    @additional_information = AdditionalInformation.find_by(inn: Inn.last.id)
  end

  def update
    @additional_information = AdditionalInformation.find_by(inn: Inn.last.id)
    @additional_information.update(additional_information_params)
    redirect_to my_inn_path, notice: 'Informações adicionais atualizadas com sucesso'
  end

  private

  def additional_information_params
    params.require(:additional_information).permit(:description, :policies, :check_in, :check_out, :pets)
  end
end