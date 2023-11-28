class Innkeeper::ReviewsController < ApplicationController
  def index
    @reviews = current_user.inn.reviews
  end

  def edit
    @review = Review.find(params[:id])
    verify_review()
  end

  def update
    @review = Review.find(params[:id])
    verify_review()    

    @review.update!(answer: params[:review][:answer])
    redirect_to innkeeper_reviews_path
  end

  private

  def verify_review
    return redirect_to root_path if @review.reservation.room.inn != current_user.inn
    return redirect_to root_path if @review.reservation.status != 'finished'
    return redirect_to root_path if @review.answer.present?
  end
end