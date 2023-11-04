class HomeController < ApplicationController
  before_action :force_inn_creation, only: [:home]
  
  def home
  end
end