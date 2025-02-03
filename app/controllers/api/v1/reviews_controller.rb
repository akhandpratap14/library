class Api::V1::ReviewsController < ApiController
  
  def create
    book = Book.find(params[:book_id])
    review = book.reviews.create(user: current_user, rating: params[:rating], comment: params[:comment])

    book.update(avg_rating: book.reviews.average(:rating))

    render json: review, status: :created
  end

  def index
    book = Book.find(params[:book_id])
    render json: book.reviews
  end

end
