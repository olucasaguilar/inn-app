require 'rails_helper'

describe 'Inn keeper adds a room' do
  it 'from my_inn_path' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    # Act
    login_as(user)
    visit my_inn_path
    click_on 'Adicionar quarto'
    # Assert
    expect(page).to have_content 'Adicionar Quarto'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Dimensão'
    expect(page).to have_field 'Quantidade máxima de pessoas'
    expect(page).to have_field 'Valor da diária'

    expect(page).to have_field 'Banheiro'
    expect(page).to have_field 'Varanda'
    expect(page).to have_field 'Ar condicionado'
    expect(page).to have_field 'TV'
    expect(page).to have_field 'Guarda-roupa'
    expect(page).to have_field 'Cofre'
    expect(page).to have_field 'Acessibilidade'
  end

  it 'successfully' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    # Act
    login_as(user)
    visit my_inn_path
    click_on 'Adicionar quarto'
    fill_in 'Nome', with: 'Quarto Azul'
    fill_in 'Descrição', with: 'Quarto com vista para o mar'
    fill_in 'Dimensão', with: '12'
    fill_in 'Quantidade máxima de pessoas', with: '2'
    fill_in 'Valor da diária', with: '100'
    click_on 'Criar Quarto'
    # Assert
    expect(page).to have_content 'Quarto Azul adicionado com sucesso'
    expect(user.inn.rooms.count).to eq 1
  end

  it 'and must fill all fields' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    # Act
    login_as(user)
    visit my_inn_path
    click_on 'Adicionar quarto'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Dimensão', with: ''
    fill_in 'Quantidade máxima de pessoas', with: ''
    fill_in 'Valor da diária', with: ''
    click_on 'Criar Quarto'
    # Assert
    expect(page).not_to have_content 'Quarto Azul adicionado com sucesso'
    expect(page).to have_content 'Não foi possível adicionar o quarto'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Dimensão não pode ficar em branco'
    expect(page).to have_content 'Quantidade máxima de pessoas não pode ficar em branco'
    expect(page).to have_content 'Valor da diária não pode ficar em branco'
    expect(user.inn.rooms.count).to eq 0
  end

  it 'and fill optional fields' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    # Act
    login_as(user)
    visit my_inn_path
    click_on 'Adicionar quarto'
    fill_in 'Nome', with: 'Quarto Azul'
    fill_in 'Descrição', with: 'Quarto com vista para o mar'
    fill_in 'Dimensão', with: '12'
    fill_in 'Quantidade máxima de pessoas', with: '2'
    fill_in 'Valor da diária', with: '100'
    check 'Banheiro'
    check 'Varanda'
    check 'Ar condicionado'
    check 'TV'
    check 'Guarda-roupa'
    check 'Cofre'
    check 'Acessibilidade'
    click_on 'Criar Quarto'
    # Assert
    quarto = user.inn.rooms.first
    expect(quarto.bathroom).to eq true
    expect(quarto.balcony).to eq true
    expect(quarto.air_conditioning).to eq true
    expect(quarto.tv).to eq true
    expect(quarto.wardrobe).to eq true
    expect(quarto.safe).to eq true
    expect(quarto.accessible).to eq true
  end
end