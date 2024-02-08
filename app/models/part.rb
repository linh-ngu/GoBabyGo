class Part < ApplicationRecord
    belongs_to :car, optional: true
end
