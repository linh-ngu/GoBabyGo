class CreateApplicationNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :application_notes do |t|
      t.string :content

      t.timestamps
    end
  end
end
