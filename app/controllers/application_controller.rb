class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:home]
  before_action :configure_permitted_parameters, if: :devise_controller?

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
    redirect_to new_inn_path if current_user && current_user.innkeeper? && current_user.inn.blank?
  end

  def block_guests
    redirect_to root_path unless current_user.innkeeper?
  end
end
