class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  has_many :renewal_requests, dependent: :destroy

  before_create :set_due_date

  scope :overdue, -> { where("due_date < ? AND returned = ?", Time.zone.now, false) }

  def renew
    return false if returned

    update(due_date: due_date + 15.seconds)
  end

  private

  def set_due_date
    self.due_date = Time.zone.now + 15.seconds 
  end
end
