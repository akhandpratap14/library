class AddIsLostAndIsDamagedToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :is_lost, :boolean, default: false, null: false
    add_column :books, :is_damaged, :boolean, default: false, null: false
  end
end
 