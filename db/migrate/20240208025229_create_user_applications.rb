class CreateUserApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :user_applications do |t|
      t.string :child_name
      t.date :child_birthdate
      t.text :primary_diagnosis
      t.string :secondary_diagnosis
      t.integer :child_height
      t.integer :child_weight
      t.string :caregiver_name
      t.string :caregiver_email
      t.integer :caregiver_phone
      t.boolean :can_transport
      t.boolean :can_store
      t.text :notes
      t.integer :eligibility
      t.boolean :accepted

      t.timestamps
    end
  end
end
