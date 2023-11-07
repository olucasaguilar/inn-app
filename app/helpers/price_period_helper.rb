module PricePeriodHelper
  def price_period_display(price_period)
    "#{price_period.start_date.strftime('%d/%m/%Y')} a #{price_period.end_date.strftime('%d/%m/%Y')}"
  end 
  
  def delete_button(room, price_period)
    button_to "Apagar", price_period_path(room, price_period), method: :delete, form: { data: { turbo_confirm: 'Tem certeza?' } }
  end
end