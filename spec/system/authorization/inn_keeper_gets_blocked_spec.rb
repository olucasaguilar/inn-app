require 'rails_helper'

describe 'Inn keeper gets blocked' do
  it 'trying to access new_inn_path again' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    # Act
    visit new_inn_path
    # Assert
    expect(current_path).to eq my_inn_path
  end

  it 'trying to edit someone else\'s payment methods' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'teste@gmail.com', address: address, user: user)
    PaymentMethod.create!(name: 'Cartão de crédito', inn_additional: inn.inn_additional)
    # Arrange
    user2 = User.create!(name: 'Pedro', email: 'pedro@gmail.com', password: '654321', innkeeper: true)
    address2 = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                          state: 'PR', city: 'Paulo', zip_code: '12312312')
    inn2 = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                      cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                      address: address2, user: user2)
    # Act
    login_as(user2)
    visit edit_payment_method_path(PaymentMethod.last)
    expect(current_path).to eq my_inn_path
  end

  it 'trying to edit someone else\'s room' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200, inn: inn)
    user2 = User.create!(name: 'Pedro', email: 'pedro@gmail.com', password: '654321', innkeeper: true)
    address2 = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                          state: 'PR', city: 'Paulo', zip_code: '12312312')
    inn2 = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                      cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                      address: address2, user: user2)
    login_as(user2)
    visit edit_room_path(Room.last)
    expect(current_path).to eq my_inn_path
  end
end