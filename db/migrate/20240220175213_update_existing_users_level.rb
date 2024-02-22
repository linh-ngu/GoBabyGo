class UpdateExistingUsersLevel < ActiveRecord::Migration[7.0]
  def change
    # Update all existing records where level is NULL to be 0
    User.where(level: nil).update_all(level: 0)
  end
end
