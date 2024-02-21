class User < ApplicationRecord
    has_many :user_applications
    belongs_to :admin, optional: true
    validates :email, presence: true, uniqueness: true , format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, allow_blank: true }
    validates :phone, presence: true, length: { is: 10, allow_blank: true }
end
