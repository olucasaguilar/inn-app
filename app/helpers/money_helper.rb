module MoneyHelper
  def number_currency(number)
    number_to_currency(number.to_s.insert(-3, ','))
  end
end