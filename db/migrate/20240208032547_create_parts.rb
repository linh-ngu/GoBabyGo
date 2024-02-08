class CreateParts < ActiveRecord::Migration[7.0]
  def change
    create_table :parts do |t|
      t.string :part_name
      t.float :part_price
      t.string :purchase_source
      t.integer :quantity_purchased

      t.timestamps
    end
  end
end
