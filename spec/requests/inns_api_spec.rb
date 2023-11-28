require 'rails_helper'

describe 'Inn API' do
  context 'GET /api/v1/inns' do
    it 'successfully' do
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
      # Act
      get "/api/v1/inns/"
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      #
      expect(json_response.first["name"]).to eq "Pousada do Alemão"
      expect(json_response.first["social_name"]).to eq "Pousada do Alemão LTDA"
      expect(json_response.first["cnpj"]).to eq "12345678901234"
      expect(json_response.first["phone"]).to eq "11999999999"
      expect(json_response.first["status"]).to eq "active"
      expect(json_response.first["address"]["street"]).to eq "Rua dos Bobos, 115"
      expect(json_response.first["address"]["neighborhood"]).to eq "Vila Madalena"
      expect(json_response.first["address"]["state"]).to eq "SP"
      expect(json_response.first["address"]["city"]).to eq "São Paulo"
      expect(json_response.first["address"]["zip_code"]).to eq "05412000"
      #
      expect(json_response.last["name"]).to eq "Pousada do Russo"
      expect(json_response.last["social_name"]).to eq "Pousada do Russo LTDA"
      expect(json_response.last["cnpj"]).to eq "3123123123123123"
      expect(json_response.last["phone"]).to eq "22222222222"
      expect(json_response.last["status"]).to eq "active"
      expect(json_response.last["address"]["street"]).to eq "Rua dos Tolos, 115"
      expect(json_response.last["address"]["neighborhood"]).to eq "Vila Madarena"
      expect(json_response.last["address"]["state"]).to eq "PR"
      expect(json_response.last["address"]["city"]).to eq "Paulo"
      expect(json_response.last["address"]["zip_code"]).to eq "12312312"
      #
      expect(json_response.first.keys).not_to include "created_at"
      expect(json_response.first.keys).not_to include "updated_at"
      expect(json_response.last.keys).not_to include "created_at"
      expect(json_response.last.keys).not_to include "updated_at"
    end

    it 'and filter by search' do
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
      # Act
      get "/api/v1/inns?search=Alem"
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      #
      expect(json_response.first["name"]).to eq "Pousada do Alemão"
    end

    it 'return empty if there is no inns' do
      # Act
      get "/api/v1/inns"
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response).to eq []
    end

    it 'and raise internal error' do
      # Arrange
      allow(Inn).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)
      # Act
      get "/api/v1/inns"
      # Assert
      expect(response).to have_http_status(500)
    end
  end
end
