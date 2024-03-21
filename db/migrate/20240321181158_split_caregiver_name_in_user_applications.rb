class SplitCaregiverNameInUserApplications < ActiveRecord::Migration[7.0]
  def up
    add_column :user_applications, :caregiver_first_name, :string
    add_column :user_applications, :caregiver_last_name, :string

    UserApplication.reset_column_information
    UserApplication.find_each do |ua|
      ua.caregiver_first_name, ua.caregiver_last_name = ua.caregiver_name.split(' ', 2)
      ua.save!
    end

    remove_column :user_applications, :caregiver_name
  end

  def down
    add_column :user_applications, :caregiver_name, :string

    UserApplication.find_each do |ua|
      ua.update(caregiver_name: [ua.caregiver_first_name, ua.caregiver_last_name].join(' '))
    end

    remove_column :user_applications, :caregiver_first_name
    remove_column :user_applications, :caregiver_last_name
  end
end