class AddWaitlistToUserApplications < ActiveRecord::Migration[7.0]
  def change
    add_column(:user_applications, :waitlist, :boolean, index: true, default: false)
  end
end
