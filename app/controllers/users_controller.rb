class UsersController < ApplicationController
  before_action :set_user, only: [:update, :update_role]

  def index
  end

  def show
  end

  def new
    @user = User.new(email: current_admin.email, admin_id: current_admin.id, level: :applicant)
  end

  def update
  
  end

  def update_role
    if @user.update(user_params)
      redirect_to request.referer , notice: "User role for #{@user.email} was successfully updated to #{user_params[:level]}"
    else
      redirect_to request.referer, alert: "Unable to update user role for #{@user.email} to #{user_params[:level]}"
    end
  end

  def create
    @user = User.new(user_params)
    @admin = Admin.find_by(id: current_admin.id)
    @admin.update(user_account_created: true)
    if @user.save
      @admin.save
      redirect_to root_path, :action => 'show'
    else
      render('new')
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :admin_id,
      :email,
      :phone,
      :level
    )
  end

  def set_user
    # sets user with the ID param passed into the url
    @user = User.find(params[:id])
  end


end
