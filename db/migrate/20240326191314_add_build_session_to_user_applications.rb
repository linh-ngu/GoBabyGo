class AddBuildSessionToUserApplications < ActiveRecord::Migration[7.0]
  def up
    add_column :user_applications, :build_session, :string
    UserApplication.update_all(build_session: 'Fall 2024')
  end

  def down
    remove_column :user_applications, :build_session
  end
end
