class HomeController < ApplicationController
  before_action :authenticate_user!,    except: [:home]
  before_action :block_guests,          except: [:home]

  def home
    @recent_inns = Inn.where(status: :active).order(created_at: :desc).limit(3)
    @inns = Inn.where(status: :active) - @recent_inns

    inns = @recent_inns + @inns
    @cities = inns.map { |i| i.address.city }.uniq
  end
end