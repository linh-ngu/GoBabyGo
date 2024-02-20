class User < ApplicationRecord
    has_many :user_applications
    belongs_to :admin, optional: true

    enum level: {
        applicant: 1,
        staff_member: 2,
        officer_member: 3,
        admin: 4
    }

end
