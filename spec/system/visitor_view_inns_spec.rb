require 'rails_helper'

describe 'Visitor view inns' do
  it 'from the homepage' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)
    third_address = Address.new(street: 'Avenida das Flores, 500', neighborhood: 'Jardim Primavera',
                                state: 'RJ', city: 'Rio de Janeiro', zip_code: '22334455')
    Inn.create!(name: 'Hotel Primavera', social_name: 'Hotel Primavera LTDA',
                cnpj: '98765432109876', phone: '2122223333', email: 'hotelprimavera@example.com',
                address: third_address, user: innkeeper, status: :active)
    fourth_address = Address.new(street: 'Praça Central, 70', neighborhood: 'Centro',
                                 state: 'MG', city: 'Belo Horizonte', zip_code: '54321098')
    Inn.create!(name: 'Hotel Minas Gerais', social_name: 'Hotel Minas Gerais LTDA',
                cnpj: '56789012345670', phone: '3133334444', email: 'hotelmg@example.com',
                address: fourth_address, user: innkeeper, status: :active)

    # Act
    visit root_path

    # Assert
    expect(page).to have_content 'Lista de Pousadas'

    within 'div#recent-inns' do
      expect(page).to have_content 'Recentes'
      expect(page).to have_link 'Hotel Minas Gerais'
      expect(page).to have_content 'Cidade: Belo Horizonte'

      expect(page).to have_link 'Hotel Primavera'
      expect(page).to have_content 'Cidade: Paulo'

      expect(page).to have_link 'Pousada do Russo'
      expect(page).to have_content 'Cidade: Rio de Janeiro'

      expect(page).not_to have_link 'Pousada do Alemão'
      expect(page).not_to have_content 'Cidade: São Paulo'
    end

    within 'div#inns' do
      expect(page).to have_link 'Pousada do Alemão'
      expect(page).to have_content 'Cidade: São Paulo'
    end
  end
end
