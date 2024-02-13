class AddUserAccountCreatedToAdmin < ActiveRecord::Migration[7.0]
  def change
    add_column(:admins, :user_account_created, :boolean, default: false, index: true)
  end
end
