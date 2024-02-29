class AddUserApplicationToApplicationNotes < ActiveRecord::Migration[7.0]
  def change
    add_reference :application_notes, :user_application, null: false, foreign_key: true
  end
end
