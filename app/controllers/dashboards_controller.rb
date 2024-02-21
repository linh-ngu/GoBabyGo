class DashboardsController < ApplicationController
  def show
    if current_admin.user_account_created == false
      redirect_to new_user_path
    else
      @user = User.find_by(admin_id: current_admin.id)
      @users = User.where(level: User.levels[:visitor])

      if @user.applicant?
        render 'show_user'
      elsif @user.officer_member?
        render 'show_officer'
      elsif @user.admin?
        render 'show_admin'
      else
        render 'show_user'
      end
    end
  end

  def show_table_users
    if current_admin.user_account_created == false
      redirect_to new_user_path
    else
      @user = User.find_by(admin_id: current_admin.id)
      @user_level = @user.level if @user.present?
      @users = User.where(level: User.levels[:visitor])

      if @user.applicant?
        render 'show_user'
      elsif @user.officer_member?
        render 'show_officer'
      elsif @user.admin?
        render 'show_admin'
      else
        render 'show_user'
      end
    end
  end


end
