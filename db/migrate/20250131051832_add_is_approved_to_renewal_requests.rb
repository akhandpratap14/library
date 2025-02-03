class AddIsApprovedToRenewalRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :renewal_requests, :is_approved, :boolean
  end
end
