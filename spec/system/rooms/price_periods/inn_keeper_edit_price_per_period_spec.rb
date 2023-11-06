require 'rails_helper'

describe 'Inn keeper edit a rooms prices per period page' do
  it 'successfully' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 2, value: 200, inn: inn)
    PricePeriod.create!(start_date: "2015-01-01", end_date: "2015-01-10", value: 100, room: room)
    # Act
    login_as(user)
    visit room_path(room)
    click_on 'Preços por período'
    click_on '01/01/2015 a 10/01/2015'
    fill_in 'Data de início', with: '15/01/2021'
    fill_in 'Data de término', with: '20/01/2021'
    fill_in 'Valor', with: '350'
    click_on 'Atualizar Preço por Período'
    # Assert
    expect(page).to have_content 'Preço por período atualizado com sucesso'
    expect(page).to have_content 'Preços por período'
    expect(page).to have_content '15/01/2021 a 20/01/2021'
    expect(page).to have_content 'R$ 350,00'
  end
end