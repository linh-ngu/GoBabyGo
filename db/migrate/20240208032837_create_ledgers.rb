class CreateLedgers < ActiveRecord::Migration[7.0]
  def change
    create_table :ledgers do |t|
      t.float :total_expense

      t.timestamps
    end
  end
end
