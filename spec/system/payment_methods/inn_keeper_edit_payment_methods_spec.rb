require 'rails_helper'

# dono de pousada edita pousada
describe 'Inn Keeper edit payment methods' do
  it 'successfully' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    pm = PaymentMethod.create!(name: 'Cartão de crédito')

    visit my_inn_path
    within 'dl#payment_methods' do
      click_on 'Editar'
    end
    expect(page).to have_content 'Editar Forma de pagamento'
    expect(page).to have_field 'Nome', with: 'Cartão de crédito'

    fill_in 'Nome', with: 'Pix'
    click_on 'Atualizar Forma de pagamento'

    expect(page).to have_content 'Forma de pagamento atualizada com sucesso'
    expect(page).not_to have_content 'Cartão de crédito'
    expect(page).to have_content 'Pix'
  end

  it 'and must fill in all fields' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    pm = PaymentMethod.create!(name: 'Cartão de crédito')

    visit my_inn_path
    within 'dl#payment_methods' do
      click_on 'Editar'
    end
    fill_in 'Nome', with: ''
    click_on 'Atualizar Forma de pagamento'

    expect(page).not_to have_content 'Forma de pagamento adicionada com sucesso'
    expect(page).to have_content 'Forma de pagamento não atualizada'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end
