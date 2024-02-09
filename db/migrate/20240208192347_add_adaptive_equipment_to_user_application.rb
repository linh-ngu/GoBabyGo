class AddAdaptiveEquipmentToUserApplication < ActiveRecord::Migration[7.0]
  def change
    add_column(:user_applications, :adaptive_equipment, :text)
  end
end
