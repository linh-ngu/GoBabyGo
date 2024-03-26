class CarType < ApplicationRecord
    has_many :cars
    validates :name, presence: true
    validates :max_height, presence: true
    validates :max_weight, presence: true
    validates :price, presence: true
end
