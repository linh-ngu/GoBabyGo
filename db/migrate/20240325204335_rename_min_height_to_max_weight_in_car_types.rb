class RenameMinHeightToMaxWeightInCarTypes < ActiveRecord::Migration[7.0]
  def change
    rename_column :car_types, :min_height, :max_weight
  end
end
