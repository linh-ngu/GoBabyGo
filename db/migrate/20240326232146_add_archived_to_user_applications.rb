class AddArchivedToUserApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :user_applications, :archived, :boolean, default: false

    UserApplication.update_all(archived: false)
  end
end
