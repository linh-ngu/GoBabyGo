class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
    @user = User.new(email: current_admin.email, admin_id: current_admin.id, level: 0)
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

  def edit
    @user = User.find_by(admin_id: current_admin.id)
  end

  def update
    @user = User.find_by(admin_id: current_admin.id)
    if @user.update(user_params)
      redirect_to dashboard_path
    else
      render('edit')
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :admin_id,
      :email,
      :phone
    )
  end
end
