class Car < ApplicationRecord
    has_and_belongs_to_many :parts
    belongs_to :car_type
    belongs_to :finance
    belongs_to :user_application, optional: true
end
