class ChangePhoneToBigIntInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :user_applications, :caregiver_phone, :bigint
  end
end
