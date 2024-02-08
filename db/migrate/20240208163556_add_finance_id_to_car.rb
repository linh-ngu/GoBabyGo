class AddFinanceIdToCar < ActiveRecord::Migration[7.0]
  def change
    add_column(:cars, :finance_id, :integer, index: true)
  end
end
