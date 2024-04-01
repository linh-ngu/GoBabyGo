class AddCreatorToApplicationNotes < ActiveRecord::Migration[7.0]
  def change
    add_reference :application_notes, :creator, foreign_key: { to_table: :users }
  end
end
