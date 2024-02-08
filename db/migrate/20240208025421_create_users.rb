class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :level
      t.integer :phone

      t.timestamps
    end
  end
end
