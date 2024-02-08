class AddUserApplicationIdToCar < ActiveRecord::Migration[7.0]
  def change
    add_column(:cars, :user_application_id, :integer, index: true)
  end
end
