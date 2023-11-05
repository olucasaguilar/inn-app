require 'rails_helper'

describe 'Inn keeper edits a room' do
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
    within 'dl#rooms' do
      click_on 'Editar'
    end
    # Assert
    expect(page).to have_content 'Editar Quarto'
    expect(page).to have_field 'Nome', with: 'Quarto 1'
    expect(page).to have_field 'Descrição', with: 'Quarto com vista para o mar'
    expect(page).to have_field 'Dimensão', with: '20'
    expect(page).to have_field 'Quantidade máxima de pessoas', with: '2'
    expect(page).to have_field 'Valor da diária', with: '200'
    expect(page).to have_field 'Banheiro', checked: false
  end

  it 'successfully' do
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
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Quarto Azul'
    fill_in 'Descrição', with: 'Quarto com vista para o mar'
    check 'Banheiro'
    click_on 'Atualizar Quarto'
    # Assert
    expect(page).to have_content 'Quarto Azul atualizado com sucesso'
    expect(page).to have_content 'Nome: Quarto Azul'
    expect(page).to have_content 'Descrição: Quarto com vista para o mar'
    expect(page).to have_content 'Banheiro: Sim'
  end

  it 'and must fill all fields' do
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
      click_on 'Editar'
    end
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Dimensão', with: ''
    click_on 'Atualizar Quarto'
    # Assert
    expect(page).not_to have_content 'Quarto Azul atualizado com sucesso'
    expect(page).to have_content 'Não foi possível atualizar o quarto'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Dimensão não pode ficar em branco'
  end
end