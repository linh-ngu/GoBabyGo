class UserApplication < ApplicationRecord
    has_one :car
    belongs_to :user, optional: true
    validates :child_name, presence: true
    validates :child_birthdate, presence: true
    validates :primary_diagnosis, presence: true
    validates :child_height, presence: true
    validates :child_weight, presence: true
    validates :caregiver_name, presence: true
    validates :caregiver_email, presence: true
    validates :caregiver_phone, presence: true
    validates :can_transport, inclusion: { in: [true, false] }
    validates :can_store, inclusion: { in: [true, false] }
end
