class UpdateCreatorForExistingApplicationNotes < ActiveRecord::Migration[7.0]
  def up
    ApplicationNote.update_all(creator_id: 3)
    change_column_null :application_notes, :creator_id, false
  end

  def down
    change_column_null :application_notes, :creator_id, true
  end
end