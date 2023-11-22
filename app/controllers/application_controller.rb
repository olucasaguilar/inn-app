class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :force_inn_creation
  before_action :force_guest_add_personal_info
  before_action :block_guests

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :innkeeper])
  end
  
  def redirect_inn_keeper_out
    if current_user && current_user.inn.present?
      redirect_to my_inn_path
    end
  end

  def force_inn_creation
    return if params[:controller].include?('devise')
    redirect_to new_inn_path if current_user && current_user.innkeeper? && current_user.inn.blank?
  end

  def block_guests
    return if params[:controller].include?('devise')
    redirect_to root_path unless current_user.innkeeper?
  end

  def force_guest_add_personal_info
    if current_user && !current_user.innkeeper? && current_user.guest_user.cpf.nil?
      redirect_to edit_guest_user_path(current_user.guest_user)
    end
  end
end
