class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_one_attached :cover_image

  validates :title, :author, :description, :total_copies, :genre, :publication_details, presence: true
  validates :total_copies, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :available_copies, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  def cover_image_url
    return nil unless cover_image.attached?
    Rails.application.routes.url_helpers.rails_blob_url(cover_image, host: Rails.application.routes.default_url_options[:host])
  end


  def serialize_book
    as_json(
      only: [:id, :title, :author, :isbn, :description, :total_copies, :available_copies, :genre, :publication_details, :avg_rating, :is_lost, :is_damaged]
    ).merge(cover_image_url: cover_image_url)
  end
end
