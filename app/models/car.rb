class Car < ApplicationRecord
    has_and_belongs_to_many :parts
    belongs_to :car_type
    belongs_to :finance, optional: true
    belongs_to :user_application, optional: true
    has_many :notes
    validates :car_type_id, presence: true
end
