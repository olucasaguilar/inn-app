class AdvancedSearchesController < ApplicationController
  before_action :authenticate_user!,    except: [:search, :results]
  before_action :block_guests,          except: [:search, :results]

  def search; end

  def results
    @inns = Inn.where(status: :active).select { |inn| inn_meets_requirements?(inn)}
  end

  private

  def inn_meets_requirements?(inn)
    return false if params[:pets]       == '1' && inn.inn_additional.pets == false
    return false if params[:bathroom]   == '1' && inn.rooms.where(bathroom: true, status: true).empty?
    return false if params[:balcony]    == '1' && inn.rooms.where(balcony: true, status: true).empty?
    return false if params[:air]        == '1' && inn.rooms.where(air_conditioning: true, status: true).empty?
    return false if params[:tv]         == '1' && inn.rooms.where(tv: true, status: true).empty?
    return false if params[:wardrobe]   == '1' && inn.rooms.where(wardrobe: true, status: true).empty?
    return false if params[:safe]       == '1' && inn.rooms.where(safe: true, status: true).empty?
    return false if params[:accessible] == '1' && inn.rooms.where(accessible: true, status: true).empty?
    true
  end
end
