class DashboardsController < ApplicationController

  before_action :require_admin

  def require_admin
    unless admin_signed_in?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
  end

  def show
    if current_admin.user_account_created == false
      # executes if user is visitor (if visitor, they havn't signed up yet)
      redirect_to new_user_path
    else
      @user = User.find_by(admin_id: current_admin.id)
      @users = User.where(level: User.levels[:visitor])
      if @user.applicant? || @user.visitor?
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
      
      sorting_option = case params[:sort_option]
        when "name_asc"
          :asc
        when "name_desc"
          :desc
        else
        :desc 
        end

        @all_users = User.order(last_name: sorting_option)
        if params[:visitor] == "1" || params[:applicant] == "1" || params[:staff] == "1" || params[:officer] == "1" || params[:admin] == "1"
          selected_users = @all_users.none
          selected_users = selected_users.or(@all_users.where(level: User.levels[:visitor])) if params[:visitor] == "1"
          selected_users = selected_users.or(@all_users.where(level: User.levels[:applicant])) if params[:applicant] == "1"
          selected_users = selected_users.or(@all_users.where(level: User.levels[:staff_member])) if params[:staff] == "1"
          selected_users = selected_users.or(@all_users.where(level: User.levels[:officer_member])) if params[:officer] == "1"
          selected_users = selected_users.or(@all_users.where(level: User.levels[:admin])) if params[:admin] == "1"
          @all_users = selected_users
        end
    end
    # directs user to proper users_table view
    # user w/o permission --> back to home
    if @user.applicant? || @user.visitor?
      render 'show_user'
      # user w/GoBabyGo permission --> user_table
    # GoBabyGo permission meaning Member, Officer, Admin
    else
      render 'users_table'
    end

  end


end
