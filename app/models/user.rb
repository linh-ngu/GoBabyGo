class User < ApplicationRecord
    has_many :user_applications
    belongs_to :admin, optional: true
end
