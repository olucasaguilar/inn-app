require 'rails_helper'

describe 'New inn keeper gets blocked' do
  it 'trying to access my_inn_path' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    # Act
    login_as(user)
    visit my_inn_path
    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).to have_field 'Nome fantasia'
  end

  it 'trying to access edit_inn_path' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    # Act
    login_as(user)
    visit edit_inn_path
    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).to have_field 'Nome fantasia'
  end

  it 'trying to access new_room_path' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    # Act
    login_as(user)
    visit new_room_path
    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).to have_field 'Nome fantasia'
  end

  it 'trying to access edit_room_path' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    # Act
    login_as(user)
    visit edit_room_path(1)
    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).to have_field 'Nome fantasia'
  end
end