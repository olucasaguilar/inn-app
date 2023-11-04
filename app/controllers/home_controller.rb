class HomeController < ApplicationController
  before_action :force_inn_creation, only: [:home]
  
  def home
    if user_signed_in?
      @inns = Inn.where(status: :active)
    end
  end
end