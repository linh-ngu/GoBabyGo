class Note < ApplicationRecord
    belongs_to :car 
    belongs_to :user
    validates :content, presence: true
end
