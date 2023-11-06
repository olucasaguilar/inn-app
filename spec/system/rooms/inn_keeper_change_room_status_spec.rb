require 'rails_helper'

describe 'Inn keeper changes room status' do
  it 'from my_inn_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200, inn: inn)
    # Act
    login_as(user)
    visit my_inn_path
    # Assert
    expect(page).to have_content 'Disponível para reserva: Não'
  end

  context 'successfully' do
    it 'to true' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: user)
      Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                  max_occupancy: 2, value: 200, inn: inn)
      # Act
      login_as(user)
      visit my_inn_path
      within 'dl#rooms' do
        click_on 'Disponibilizar'
      end
      # Assert
      expect(page).to have_content 'Disponível para reserva: Sim'
    end

    it 'to false' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: user)
      Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                  max_occupancy: 2, value: 200, inn: inn, status: true)
      # Act
      login_as(user)
      visit my_inn_path
      within 'dl#rooms' do
        click_on 'Indisponibilizar'
      end
      # Assert
      expect(page).to have_content 'Disponível para reserva: Não'
    end
  end
end