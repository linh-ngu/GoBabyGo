class UpdateBuildSessionToFall2024 < ActiveRecord::Migration[7.0]
  def up
    UserApplication.update_all(build_session: 'Fall 2024')
  end

  def down
    # Raise an error to prevent irreversible data loss
    raise ActiveRecord::IrreversibleMigration
  end
end