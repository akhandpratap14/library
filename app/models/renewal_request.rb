class RenewalRequest < ApplicationRecord
  belongs_to :borrowing
  

  after_update :extend_due_date, if: -> { saved_change_to_is_approved? && is_approved? }

  private

  def extend_due_date
    borrowing.update(due_date: borrowing.due_date + 14.days) if borrowing&.due_date
  end
end
