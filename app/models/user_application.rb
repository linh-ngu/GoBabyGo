class UserApplication < ApplicationRecord
    has_one :car
    has_many :application_notes
    belongs_to :user, optional: true
    validates :child_name, presence: true, format: { without: /\d/, message: "cannot contain a number" }
    validates :child_birthdate, presence: true
    validates :primary_diagnosis, presence: true
    validates :child_height, presence: true
    validates :child_weight, presence: true
    validates :caregiver_name, presence: true, format: { without: /\d/, message: "cannot contain a number" }
    validates :caregiver_email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, allow_blank: true }
    validates :caregiver_phone, presence: true, length: { is: 10, allow_blank: true }
    validates :can_transport, inclusion: { in: [true, false] }
    validates :can_store, inclusion: { in: [true, false] }
end