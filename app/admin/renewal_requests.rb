ActiveAdmin.register RenewalRequest do
  permit_params :borrowing_id, :is_approved

  index do
    selectable_column
    id_column
    column "User", sortable: "borrowings.user_id" do |renewal|
      link_to renewal.borrowing.user.username, admin_user_path(renewal.borrowing.user)
    end
    column "Book", sortable: "borrowings.book_id" do |renewal|
      link_to renewal.borrowing.book.title, admin_book_path(renewal.borrowing.book)
    end
    column :is_approved
    column "Due Date", sortable: "borrowings.due_date" do |renewal|
      renewal.borrowing.due_date.strftime("%d %b %Y %H:%M:%S") if renewal.borrowing
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Renewal Request Details" do
      f.input :borrowing, as: :select, collection: Borrowing.includes(:user, :book).map { |b| ["#{b.user.username} - #{b.book.title}", b.id] }
      f.input :is_approved, as: :boolean
    end

    f.inputs "Extend Due Date" do
      f.input :borrowing, input_html: { disabled: true }, label: "Current Due Date", hint: f.object.borrowing.due_date.strftime("%d %b %Y %H:%M:%S")
      f.input :borrowing_due_date, as: :datetime_picker, label: "New Due Date", input_html: { value: f.object.borrowing.due_date + 15.seconds }
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row "User" do |renewal|
        link_to renewal.borrowing.user.username, admin_user_path(renewal.borrowing.user)
      end
      row "Book" do |renewal|
        link_to renewal.borrowing.book.title, admin_book_path(renewal.borrowing.book)
      end
      row :is_approved
      row "Due Date" do |renewal|
        renewal.borrowing.due_date.strftime("%d %b %Y %H:%M:%S") if renewal.borrowing
      end
      row :created_at
      row :updated_at
    end

    if !resource.is_approved && !resource.borrowing.returned
      div do
        link_to "Approve & Extend Due Date", approve_admin_renewal_request_path(resource), method: :put, class: "button"
      end
    end

    active_admin_comments
  end


  member_action :approve, method: :put do
    renewal = RenewalRequest.find(params[:id])
    borrowing = renewal.borrowing

    if borrowing.returned
      redirect_to admin_renewal_request_path(renewal), alert: "Cannot extend due date. The book has already been returned."
    else
      ActiveRecord::Base.transaction do
        renewal.update!(is_approved: true)
        borrowing.update!(due_date: borrowing.due_date + 15.seconds) 
      end
      redirect_to admin_renewal_request_path(renewal), notice: "Due date extended! New due date: #{borrowing.due_date.strftime('%d %b %Y %H:%M:%S')}"
    end
  end
end
