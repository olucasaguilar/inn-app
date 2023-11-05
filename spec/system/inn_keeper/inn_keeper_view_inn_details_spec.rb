require 'rails_helper'

describe 'Inn keeper view inn details' do
  it 'successfully' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    visit my_inn_path

    expect(page).to have_content 'Nome fantasia: Pousada do Alemão'
    expect(page).to have_content 'Razão social: Pousada do Alemão LTDA'
    expect(page).to have_content 'CNPJ: 12345678901234'
    expect(page).to have_content 'Telefone: 11999999999'
    expect(page).to have_content 'E-mail: pdalemao@gmail.com'

    expect(page).to have_content 'Rua: Rua dos Bobos, 115'
    expect(page).to have_content 'Bairro: Vila Madalena'
    expect(page).to have_content 'Cidade: São Paulo - SP'
    expect(page).to have_content 'CEP: 05412000'
    
    expect(page).to have_content 'Informações adicionais:'
    expect(page).to have_content 'Sem Descrição'
    expect(page).to have_content 'Sem Políticas'
    expect(page).to have_content 'Check-in:'
    expect(page).to have_content 'Check-out:'
    expect(page).to have_content 'Aceita Pets: Não'
  end
end