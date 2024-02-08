class UserApplication < ApplicationRecord
    belongs_to :user, optional: true
end
