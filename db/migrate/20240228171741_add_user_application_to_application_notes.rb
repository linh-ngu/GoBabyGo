class AddUserApplicationToApplicationNotes < ActiveRecord::Migration[6.0]
  def up
    add_reference :application_notes, :user_application, null: true, foreign_key: true

    # Set a default user_application_id for existing records
    # Replace `default_id` with the ID of the UserApplication you want to associate with existing ApplicationNotes
    default_id = 1
    ApplicationNote.where(user_application_id: nil).destroy_all
    change_column_null :application_notes, :user_application_id, false
  end

  def down
    remove_reference :application_notes, :user_application
  end
end