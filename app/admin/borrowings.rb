ActiveAdmin.register Borrowing do
  permit_params :user_id, :book_id, :due_date, :returned

  actions :all, except: [:destroy]

  index do
    selectable_column
    id_column
    column "User", sortable: :user_id do |borrowing|
      link_to borrowing.user.username, admin_user_path(borrowing.user)
    end
    column "Book", sortable: :book_id do |borrowing|
      link_to borrowing.book.title, admin_book_path(borrowing.book)
    end
    column :due_date
    column :returned
    actions
  end

  filter :user
  filter :book
  filter :due_date
  filter :returned


  member_action :mark_returned, method: :put do
    borrowing = Borrowing.find(params[:id])

    if borrowing.returned
      redirect_to admin_borrowings_path, alert: "Book is already returned."
    else
      ActiveRecord::Base.transaction do
        borrowing.update!(returned: true)
        
        book = borrowing.book
        if book
          book.update!(available_copies: book.available_copies + 1)
          Rails.logger.info "✅ Book #{book.id} available_copies updated to #{book.available_copies}"
        else
          Rails.logger.error "❌ Book not found for Borrowing ID: #{borrowing.id}"
        end
      end

      redirect_to admin_borrowings_path, notice: "Book marked as returned! Available copies updated."
    end
  end

  member_action :renew, method: :put do
    borrowing = Borrowing.find(params[:id])

    if borrowing.returned
      redirect_to admin_borrowings_path, alert: "Cannot renew a returned book."
    else
      borrowing.update!(due_date: borrowing.due_date + 14.days)
      redirect_to admin_borrowings_path, notice: "Book renewed successfully! New due date: #{borrowing.due_date.strftime('%d %b %Y')}"
    end
  end

  action_item :mark_returned, only: :show do
    unless resource.returned
      link_to "Mark as Returned", mark_returned_admin_borrowing_path(resource), method: :put
    end
  end

  action_item :renew, only: :show do
    unless resource.returned
      link_to "Renew", renew_admin_borrowing_path(resource), method: :put
    end
  end
end
