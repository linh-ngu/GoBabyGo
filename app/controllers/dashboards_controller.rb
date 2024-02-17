class DashboardsController < ApplicationController
  def show
    if current_admin.user_account_created == false
      redirect_to new_user_path
    else
      @user = User.find_by(admin_id: current_admin.id)
      if @user.level == 0
        render 'show_user'
      elsif @user.level ==1
        render 'show_officer'
      else
        render 'show_admin'
      end
    end
  end
  
end
