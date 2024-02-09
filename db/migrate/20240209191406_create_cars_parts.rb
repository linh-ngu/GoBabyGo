# Create a migration to create the join table
class CreateCarsParts < ActiveRecord::Migration[7.0]
  def change
    create_table :cars_parts, id: false do |t|
      t.belongs_to :car, index: true
      t.belongs_to :part, index: true
    end
  end
end

