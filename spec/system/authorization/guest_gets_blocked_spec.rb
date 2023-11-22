require 'rails_helper'

describe 'Guest gets blocked' do
  it 'trying to access new_inn_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    # Act
    login_as(user)
    visit new_inn_path
    # Assert
    expect(current_path).to eq root_path
  end

  it 'trying to access my_inn_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    # Act
    login_as(user)
    visit my_inn_path
    # Assert
    expect(current_path).to eq root_path
  end

  it 'trying to access edit_inn_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    # Act
    login_as(user)
    visit edit_inn_path
    # Assert
    expect(current_path).to eq root_path
  end

  it 'trying to access new_room_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    # Act
    login_as(user)
    visit new_room_path
    # Assert
    expect(current_path).to eq root_path    
  end

  it 'trying to access edit_room_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    # Act
    login_as(user)
    visit edit_room_path(1)
    # Assert
    expect(current_path).to eq root_path    
  end

  it 'trying to access price_periods_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    # Act
    login_as(user)
    visit price_periods_path(1)
    # Assert
    expect(current_path).to eq root_path    
  end

  it 'trying to access price_periods_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    # Act
    login_as(user)
    visit price_periods_path(1)
    # Assert
    expect(current_path).to eq root_path    
  end
end