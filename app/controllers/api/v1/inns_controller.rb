class Api::V1::InnsController < Api::V1::ApiController
  def index
    params[:search] ? inns = search_inns : inns = Inn.active

    inns = inns.as_json(except: [:created_at, :updated_at])
    inns.each do |inn|
      inn["address"] = Address.find(inn["address_id"]).as_json(except: [:created_at, :updated_at])
    end

    render status: 200, json: inns
  end

  def search_inns
    search = params[:search]
    inns  = Inn.active.where(address: Address.where("city LIKE ?", "%#{search}%"))
    inns += Inn.active.where(address: Address.where("neighborhood LIKE ?", "%#{search}%"))
    inns += Inn.active.where("name LIKE ?", "%#{search}%")
    inns  = inns.sort_by { |inn| inn.name }
    inns = inns.uniq
  end
end