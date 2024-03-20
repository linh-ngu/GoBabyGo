class Part < ApplicationRecord
    has_and_belongs_to_many :car, optional: true
    validates :part_name, presence: true
    validates :part_price, presence: true
    validates :quantity_purchased, presence: true
end
