class ReviewsController < ApplicationController
  before_action :block_guests, except: [:new, :create]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.reservation = Reservation.find(params[:reservation_id])

    return redirect_to root_path unless @review.reservation.user == current_user
    return redirect_to root_path if @review.reservation.status != 'finished'
    return redirect_to root_path if @review.reservation.review.id

    if @review.save
      flash[:notice] = 'Avaliação enviada com sucesso'
      redirect_to inn_room_reservation_path(@review.reservation.room.inn, @review.reservation.room, @review.reservation)
    else
      render :new, status: 422
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end