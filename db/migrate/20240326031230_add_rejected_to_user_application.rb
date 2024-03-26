class AddRejectedToUserApplication < ActiveRecord::Migration[7.0]
  def change
    add_column(:user_applications, :rejected, :boolean, index: true, default: false)
  end
end
