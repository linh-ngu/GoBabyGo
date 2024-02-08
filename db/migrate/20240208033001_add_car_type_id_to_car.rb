class AddCarTypeIdToCar < ActiveRecord::Migration[7.0]
  def change
    add_column(:cars, :car_type_id, :integer, index: true)
  end
end
