require 'rails_helper'

RSpec.describe AdditionalInformation, type: :model do
  describe '#nil?' do
    it 'false when additional_information is nil' do
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
      inn = Inn.create!(name: 'Pousada', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                    phone: '11999999999', email: 'alemao@gmail.com', address: address)
      result = inn.additional_information
      # Assert
      expect(result).not_to eq nil
      expect(result).to be_a AdditionalInformation
    end
  end
end
