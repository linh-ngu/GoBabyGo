class AddCarIdToParts < ActiveRecord::Migration[7.0]
  def change
    add_column(:parts, :car_id, :integer, index: true)
  end
end
