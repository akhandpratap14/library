class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.string :cover_image
      t.text :description
      t.integer :total_copies
      t.string :genre
      t.string :publication_details
      t.integer :available_copies
      t.float :avg_rating

      t.timestamps
    end
  end
end
