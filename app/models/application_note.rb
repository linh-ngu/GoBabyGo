class ApplicationNote < ApplicationRecord
    belongs_to :user_application
    validates :content, presence: true
end
