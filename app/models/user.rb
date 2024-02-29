class User < ApplicationRecord
    has_many :user_applications
    belongs_to :admin, optional: true
    has_many :notes
    has_many :cars
    validates :email, presence: true, uniqueness: true , format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, allow_blank: true }
    validates :phone, presence: true, length: { is: 10, allow_blank: true }

    enum level: {
        visitor: 0,
        applicant: 1,
        staff_member: 2,
        officer_member: 3,
        admin: 4
    }

end
