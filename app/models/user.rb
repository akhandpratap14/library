class User < ApplicationRecord

    has_secure_password

    enum :status, [ :inactive, :active, :archive ]

    validates :name, presence: true
    validates :email, presence: true
    validates :username, presence: true

    has_many :borrowings, dependent: :destroy
    has_many :reviews, dependent: :destroy

end
