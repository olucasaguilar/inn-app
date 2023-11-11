class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:home]
  before_action :force_inn_creation, only: [:home]
  
  def home
    @recent_inns = Inn.where(status: :active).order(created_at: :desc).limit(3)
    @inns = Inn.where(status: :active) - @recent_inns
  end
end