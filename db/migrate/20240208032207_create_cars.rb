class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.text :modification_details
      t.boolean :complete
      t.float :total_price

      t.timestamps
    end
  end
end
