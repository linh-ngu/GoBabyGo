class DashboardsController < ApplicationController

  def show
    if current_admin.user_account_created == false
      # executes if user is visitor (if visitor, they havn't signed up yet)
      redirect_to new_user_path
    else

      @user = User.find_by(admin_id: current_admin.id)
      @users = User.where(level: User.levels[:visitor])

      if @user.applicant?
        render 'show_user'
        # executes for roles {applicant}
      else
        # executes for roles {member,officer,admin}
        render 'show_member'
      end
    end
  end

  def show_table_users
    if current_admin.user_account_created == false
      redirect_to new_user_path
    else
      @user = User.find_by(admin_id: current_admin.id)
      @user_level = @user.level if @user.present?
      @all_users = User.all

      # directs user to proper users_table view
      # user w/o permission --> back to home
      if @user.applicant?
        render 'show_user'
        # user w/GoBabyGo permission --> user_table
      # GoBabyGo permission meaning Member, Officer, Admin
      else
        render 'users_table'
      end

    end
  end


end
