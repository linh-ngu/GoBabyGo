class SplitNamesInUserApplications < ActiveRecord::Migration[7.0]
  def up
    add_column :user_applications, :child_first_name, :string
    add_column :user_applications, :child_last_name, :string

    UserApplication.all.each do |ua|
      ua.update_columns(child_first_name: ua.child_name.split(' ', 2).first, child_last_name: ua.child_name.split(' ', 2).last)
    end

    remove_column :user_applications, :child_name
  end

  def down
    add_column :user_applications, :child_name, :string

    UserApplication.all.each do |ua|
      ua.update_columns(child_name: [ua.child_first_name, ua.child_last_name].join(' '))
    end

    remove_column :user_applications, :child_first_name
    remove_column :user_applications, :child_last_name
  end
end