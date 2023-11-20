require 'rails_helper'

describe 'Inn keeper deletes a rooms prices per period' do
  it 'successfully' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 2, value: 20000, inn: inn)
    PricePeriod.create!(start_date: "2015-01-01", end_date: "2015-01-10", value: 10000, room: room)
    PricePeriod.create!(start_date: "2015-01-20", end_date: "2015-01-30", value: 20000, room: room)
    # Act
    login_as(user)
    visit room_path(room)
    click_on 'Preços por período'
    within 'div#price_period_1' do
      click_on 'Apagar'
    end
    # Assert
    expect(page).to have_content 'Preço por período apagado com sucesso'

    expect(page).not_to have_content '01/01/2015 a 10/01/2015'
    expect(page).not_to have_content 'R$ 100,00'

    expect(page).to have_content '20/01/2015 a 30/01/2015'
    expect(page).to have_content 'R$ 200,00'
  end 
end
