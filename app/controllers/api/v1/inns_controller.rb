class Api::V1::InnsController < Api::V1::ApiController
  def index
    params[:search] ? inns = search_inns : inns = Inn.active

    inns = inns.as_json(except: [:created_at, :updated_at])
    inns.each do |inn|
      inn["address"] = Address.find(inn["address_id"]).as_json(except: [:created_at, :updated_at])
    end

    render status: 200, json: inns
  end

  def show
    inn = Inn.find(params[:id])

    response = inn.as_json(except: [:created_at, :updated_at, :social_name, :cnpj])
    response["address"] = Address.find(inn.address_id).as_json(except: [:created_at, :updated_at])
    response["average_rating"] = inn.average_rating
    response["additionals"] = inn.inn_additional.as_json(except: [:created_at, :updated_at, :id, :inn_id])

    response["additionals"]["check_in"] = inn.additionals.check_in.strftime("%H:%M")
    response["additionals"]["check_out"] = inn.additionals.check_out.strftime("%H:%M")

    render status: 200, json: response
  end

  private

  def search_inns
    search = params[:search]
    inns  = Inn.active.where(address: Address.where("city LIKE ?", "%#{search}%"))
    inns += Inn.active.where(address: Address.where("neighborhood LIKE ?", "%#{search}%"))
    inns += Inn.active.where("name LIKE ?", "%#{search}%")
    inns  = inns.sort_by { |inn| inn.name }
    inns = inns.uniq
  end
end