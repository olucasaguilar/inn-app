require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '#valid?' do
    it 'false when rating is more than 5' do
      # Arrange
      review = Review.new(rating: 6)
      # Act
      review.valid? 
      # Assert
      expect(review.errors.full_messages).to include('Nota deve ser menor ou igual a 5')
    end

    it 'false when rating is less than 0' do
      # Arrange
      review = Review.new(rating: -1)
      # Act
      review.valid? 
      # Assert
      expect(review.errors.full_messages).to include('Nota deve ser maior ou igual a 0')
    end
  end
end
