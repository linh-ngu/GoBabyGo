class UserApplication < ApplicationRecord
    has_one :car
    belongs_to :user, optional: true
end
