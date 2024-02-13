class ChangeUserPhoneToBigint < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :phone, :bigint
  end
end
