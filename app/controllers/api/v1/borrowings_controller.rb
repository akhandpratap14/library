class Api::V1::BorrowingsController < ApiController
  def create
    book = Book.find(params[:book_id])
    
    renewal_request = RenewalRequest.find_by(borrowing_id: params[:borrowing_id], is_approved: true)
  
    if renewal_request
      borrowing = renewal_request.borrowing
      borrowing.update(due_date: borrowing.due_date + 14.days)
      renewal_request.destroy  
      render json: { message: "Renewal successful! New due date: #{borrowing.due_date.strftime('%d %b %Y')}" }, status: :ok
    else
      if book.available_copies > 0
        borrowing = current_user.borrowings.create(book: book)
        book.update(available_copies: book.available_copies - 1)
        render json: borrowing, status: :created
      else
        render json: { error: "No copies available" }, status: :unprocessable_entity
      end
    end
  end

  def return
    borrowing = current_user.borrowings.find(params[:id])
  
    if borrowing.returned
      render json: { error: "Book has already been returned." }, status: :unprocessable_entity
      return
    end
  
    borrowing.update(returned: true, due_date: nil) 
    borrowing.book.update(available_copies: borrowing.book.available_copies + 1)
  
    borrowing.renewal_requests.where(is_approved: false).destroy_all 
  
    render json: { message: "Book returned successfully!" }, status: :ok
  end

  def history
    borrowings = current_user.borrowings.includes(:book) 
  
    render json: {
      data: borrowings.map do |borrowing|
        {
          id: borrowing.id,
          due_date: borrowing.due_date,
          returned: borrowing.returned,
          book: {
            id: borrowing.book.id,
            title: borrowing.book.title,
            author: borrowing.book.author,
           
            description: borrowing.book.description,
           
            genre: borrowing.book.genre,
            publication_details: borrowing.book.publication_details,
            avg_rating: borrowing.book.avg_rating,
            
            cover_image_url: borrowing.book.cover_image.attached? ? Rails.application.routes.url_helpers.url_for(borrowing.book.cover_image) : nil
          }
        }
      end
    }, status: :ok
  end
  
end
