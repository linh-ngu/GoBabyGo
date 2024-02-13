class DashboardsController < ApplicationController
  def show
    if current_admin.user_account_created == false
      redirect_to new_user_path
    else
      @user = User.find_by(admin_id: current_admin.id)
    end
  end
  
  ### DEFNE DIFFERENT VIEWS FOR OFFICER AND USER

end
