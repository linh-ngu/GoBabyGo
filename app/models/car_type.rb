class CarType < ApplicationRecord
    has_many :cars
    validates :name, presence: true
    validates :max_height, presence: true
    validates :min_height, presence: true
    validates :price, presence: true
end
