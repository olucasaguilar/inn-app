require 'rails_helper'

describe 'Inn API' do
  include ActiveSupport::Testing::TimeHelpers

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
  
  context 'GET /api/v1/inns/:id/rooms' do
    it 'successfully' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                    cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                    address: first_address, user: innkeeper, status: :active)
      Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                                max_occupancy: 2, value: 200, inn: inn, status: :active)
      Room.create!(name: 'Suite Master', description: 'Suite com vista para o mar e varanda', dimension: 30,
                                max_occupancy: 3, value: 300, inn: inn, status: :inactive)
      Room.create!(name: 'Quarto 2', description: 'Quarto com vista para o mar', dimension: 20,
                                max_occupancy: 2, value: 200, inn: inn, status: :active)
      # Act
      get "/api/v1/inns/#{inn.id}/rooms"
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      #
      expect(json_response[0]["name"]).to eq "Quarto 1"
      expect(json_response[0]["description"]).to eq "Quarto com vista para o mar"
      expect(json_response[0]["dimension"]).to eq 20
      expect(json_response[0]["max_occupancy"]).to eq 2
      expect(json_response[0]["value"]).to eq 200
      expect(json_response[0]["status"]).to eq "active"
      #
      expect(json_response[1]["name"]).to eq "Quarto 2"
      expect(json_response[1]["description"]).to eq "Quarto com vista para o mar"
      expect(json_response[1]["dimension"]).to eq 20
      expect(json_response[1]["max_occupancy"]).to eq 2
      expect(json_response[1]["value"]).to eq 200
      expect(json_response[1]["status"]).to eq "active"
      #
      expect(json_response[3]).to eq nil
      #
      expect(json_response.first.keys).not_to include "created_at"
      expect(json_response.first.keys).not_to include "updated_at"
      expect(json_response.last.keys).not_to include "created_at"
      expect(json_response.last.keys).not_to include "updated_at"      
    end

    it 'and the inn does not exist' do
      # Act
      get "/api/v1/inns/999/rooms"
      # Assert
      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq "Não encontrado"
    end

    it 'and raise internal error' do
      # Arrange
      allow(Inn).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)
      # Act
      get "/api/v1/inns/1/rooms"
      # Assert
      expect(response).to have_http_status(500)
    end
  end

  context 'GET /api/v1/inns/:id/rooms/:room_id/availability' do
    context 'successfully' do
      it 'and the room is available' do
        # Arrange
        innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: first_address, user: innkeeper, status: :active)
        room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                                  max_occupancy: 2, value: 200_00, inn: inn, status: :active)
        # Act
        get "/api/v1/inns/#{inn.id}/rooms/#{room.id}/availability?check_in=#{Date.today}&check_out=#{Date.today + 1}&guests=2"
        # Assert
        expect(response.status).to eq 200
        expect(response.content_type).to include 'application/json'
        json_response = JSON.parse(response.body)
        expect(json_response["available"]).to eq true
        expect(json_response["value"]).to eq 400_00
      end

      it 'and the room is not available' do
        # Arrange
        innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: first_address, user: innkeeper, status: :active)
        room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                                  max_occupancy: 2, value: 200_00, inn: inn, status: :active)
        reservation = Reservation.create!(check_in: 1.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                          room: room)
        # Act
        get "/api/v1/inns/#{inn.id}/rooms/#{room.id}/availability?check_in=#{Date.today}&check_out=#{Date.today + 1}&guests=2"
        # Assert
        expect(response.status).to eq 200
        expect(response.content_type).to include 'application/json'
        json_response = JSON.parse(response.body)
        expect(json_response["available"]).to eq false
        expect(json_response["value"]).to eq nil
        expect(json_response["errors"]).to eq ["O periodo informado está indisponível"]
      end
    end

    it 'and need to inform all three parameters' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                    cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                    address: first_address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                                max_occupancy: 2, value: 200_00, inn: inn, status: :active)
      reservation = Reservation.create!(check_in: 1.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                        room: room)
      # Act
      get "/api/v1/inns/#{inn.id}/rooms/#{room.id}/availability"
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["available"]).to eq false
      expect(json_response["value"]).to eq nil
      expect(json_response["errors"]).to include "Data de entrada não pode ficar em branco"
      expect(json_response["errors"]).to include "Data de saída não pode ficar em branco"
      expect(json_response["errors"]).to include "Quantidade de hóspedes não pode ficar em branco"
    end
  end

  context 'GET /api/v1/inns/:id' do
    it 'successfully' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: first_address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 20000, inn: inn, status: :active)
      guest = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
      guest.guest_user.update!(cpf: '12345678900')
      reservation_001 = Reservation.create!(check_in: 2.days.from_now, check_out: 3.days.from_now, guests: 2, 
                                            room: room, user: guest)
      reservation_002 = Reservation.create!(check_in: 4.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                            room: room, user: guest)
      reservation_003 = Reservation.create!(check_in: 6.days.from_now, check_out: 7.days.from_now, guests: 2, 
                                            room: room, user: guest)        
      travel_to 2.days.from_now do
        reservation_001.active
      end
      travel_to 3.days.from_now do
        reservation_001.finished
      end
      travel_to 4.days.from_now do
        reservation_002.active
      end
      travel_to 5.days.from_now do
        reservation_002.finished
      end
      travel_to 6.days.from_now do
        reservation_003.active
      end
      travel_to 7.days.from_now do
        reservation_003.finished
      end
      Review.create!(rating: 4, comment: 'ótimas acomodações!', reservation: reservation_001)
      Review.create!(rating: 5, comment: 'Expectacular!', reservation: reservation_002)
      Review.create!(rating: 2, comment: 'Poderia ser melhor', reservation: reservation_003)
      # Act
      get "/api/v1/inns/#{inn.id}"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)

      expect(json_response["name"]).to eq 'Pousada do Alemão'
      expect(json_response["social_name"]).to eq nil
      expect(json_response["cnpj"]).to eq nil
      expect(json_response["phone"]).to eq '11999999999'
      expect(json_response["email"]).to eq 'pdalemao@gmail.com'
      expect(json_response["address"]["street"]).to eq 'Rua dos Bobos, 115'
      expect(json_response["address"]["neighborhood"]).to eq 'Vila Madalena'
      expect(json_response["address"]["city"]).to eq 'São Paulo'
      expect(json_response["address"]["state"]).to eq 'SP'
      expect(json_response["address"]["zip_code"]).to eq '05412000'
      expect(json_response["description"]).to eq nil
      expect(json_response["average_rating"]).to eq 3
      expect(json_response["additionals"]["check_in"]).to eq '12:00'
      expect(json_response["additionals"]["check_out"]).to eq '12:00'
      expect(json_response["additionals"]["description"]).to eq nil
      expect(json_response["additionals"]["pets"]).to eq false
      expect(json_response["additionals"]["policies"]).to eq nil
    end
  end
end