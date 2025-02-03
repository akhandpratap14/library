ActiveAdmin.register Book do
  permit_params :title, :author, :description, :genre, :publication_details, :total_copies, :available_copies, :cover_image

  form do |f|
    f.inputs "Book Details" do
      f.input :title
      f.input :author
      f.input :description
      f.input :genre
      f.input :publication_details
      f.input :total_copies
      f.input :available_copies
      f.input :cover_image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :author
      row :description
      row :genre
      row :publication_details
      row :total_copies
      row :available_copies
      row :cover_image do |book|
        if book.cover_image.attached?
          image_tag url_for(book.cover_image), width: "150"
        else
          "No Image Uploaded"
        end
      end
    end
  end
end
