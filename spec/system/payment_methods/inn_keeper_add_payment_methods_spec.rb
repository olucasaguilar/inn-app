require 'rails_helper'

# dono de pousada edita pousada
describe 'Inn add payment methods' do
  it 'successfully' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    visit my_inn_path
    expect(page).to have_content 'Formas de pagamento:'
    expect(page).to have_content 'Nenhuma forma de pagamento cadastrada'
    click_on 'Adicionar Forma de pagamento'

    expect(page).to have_content 'Adicionar Forma de pagamento'
    fill_in 'Nome', with: 'Dinheiro'
    click_on 'Forma de pagamento'

    expect(page).to have_content 'Forma de pagamento adicionada com sucesso'
    expect(page).not_to have_content 'Nenhuma forma de pagamento cadastrada'
    expect(page).to have_content 'Dinheiro'
  end

  it 'and must fill in all fields' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    visit my_inn_path
    click_on 'Adicionar Forma de pagamento'
    fill_in 'Nome', with: ''
    click_on 'Criar Forma de pagamento'
    
    expect(page).not_to have_content 'Forma de pagamento adicionada com sucesso'
    expect(page).to have_content 'Forma de pagamento não adicionada'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end
