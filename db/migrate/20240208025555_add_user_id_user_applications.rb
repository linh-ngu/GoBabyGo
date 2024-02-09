class AddUserIdUserApplications < ActiveRecord::Migration[7.0]
  def change
    add_column(:user_applications, :user_id, :integer, index: true)
  end
end
