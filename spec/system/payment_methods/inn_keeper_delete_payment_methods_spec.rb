require 'rails_helper'

# dono de pousada edita pousada
describe 'Inn Keeper delete payment methods' do
  it 'successfully' do
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
    click_on 'Excluir'
    expect(current_path).to eq my_inn_path
    expect(page).to have_content 'Forma de pagamento excluída com sucesso'
    expect(page).not_to have_content 'Cartão de crédito'
  end
end
