class Api::V1::BooksController < ApiController
  before_action :set_book, only: [:show]

  def index
    query = params[:q]
    availability = params[:availability]
  
    books = Book.includes(:cover_image_attachment)
    books = books.where(
      "title ILIKE :query OR author ILIKE :query OR genre ILIKE :query OR isbn ILIKE :query",
      query: "%#{query}%"
    ) if query.present?
  
    books = books.where("available_copies > 0") if availability == "available"
    books = books.where("available_copies = 0") if availability == "unavailable"
  
    render json: { data: books.map(&:serialize_book) }, status: :ok
  end
  

  def show
    render json: { data: @book.serialize_book }, status: :ok
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Book not found" }, status: :not_found
  end
end
