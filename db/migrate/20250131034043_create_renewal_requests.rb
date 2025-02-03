class CreateRenewalRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :renewal_requests do |t|
      t.references :borrowing, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
