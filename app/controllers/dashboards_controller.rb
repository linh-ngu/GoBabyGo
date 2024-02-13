class DashboardsController < ApplicationController
  def show
    if current_admin.user_account_created == false
      redirect_to new_user_path
    end
  end

end
