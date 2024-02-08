class CreateCarTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :car_types do |t|
      t.integer :max_height
      t.integer :min_height
      t.string :name
      t.float :price
      t.integer :quantity_purchased

      t.timestamps
    end
  end
end
