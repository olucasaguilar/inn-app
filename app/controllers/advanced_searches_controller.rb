class AdvancedSearchesController < ApplicationController
  before_action :authenticate_user!,    except: [:search, :results]
  before_action :block_guests,          except: [:search, :results]
  before_action :update_params,         only:   [:search, :results]

  def search; end

  def results
    @inns = Inn.active.select { |inn| inn_meets_requirements?(inn)}
  end

  private

  def inn_meets_requirements?(inn)
    return false if params[:pets]       == '1' && inn.inn_additional.pets == false
    return false if params[:bathroom]   == '1' && inn.rooms.active.where(bathroom: true).empty?
    return false if params[:balcony]    == '1' && inn.rooms.where(balcony: true,          status: true).empty?
    return false if params[:air]        == '1' && inn.rooms.where(air_conditioning: true, status: true).empty?
    return false if params[:tv]         == '1' && inn.rooms.where(tv: true,               status: true).empty?
    return false if params[:wardrobe]   == '1' && inn.rooms.where(wardrobe: true,         status: true).empty?
    return false if params[:safe]       == '1' && inn.rooms.where(safe: true,             status: true).empty?
    return false if params[:accessible] == '1' && inn.rooms.where(accessible: true,       status: true).empty?
    true
  end

  def update_params
    @params = {}
    @params[:pets]        = true if params[:pets] == '1'
    @params[:bathroom]    = true if params[:bathroom] == '1'
    @params[:balcony]     = true if params[:balcony] == '1'
    @params[:air]         = true if params[:air] == '1'
    @params[:tv]          = true if params[:tv] == '1'
    @params[:wardrobe]    = true if params[:wardrobe] == '1'
    @params[:safe]        = true if params[:safe] == '1'
    @params[:accessible]  = true if params[:accessible] == '1'
  end
end
