class UserApplicationsController < ApplicationController
  def index
    @user = User.find_by(admin_id: current_admin.id)
    @page_title = @user.level == 0 ? "Your Applications" : "All User Applications"
    if @user.level == 0
      @user_applications = UserApplication.where(user_id: @user.id)
    elsif @user.level == 1
      @user_applications = UserApplication.order(:child_name)
    end
  end

  def show
    @user_application = UserApplication.find(params[:id])
  end

  def new
    @user_application = UserApplication.new()
  end

  def create
    @user = User.find_by(admin_id: current_admin.id)

    if @user.level == 0
      @user_application = UserApplication.new(user_params)
      flash[:notice] = "Application submitted successfully. We will reach out to you soon with our response."
    elsif @user.level == 1
      @user_application = UserApplication.new(officer_params)
      "Application submitted successfully."
    end

    params[:user_application][:caregiver_phone].gsub!(/\D/, '')
    
    @user_application.user_id = @user.id
    if @user_application.save
      redirect_to user_application_path(@user_application.id)
    else
      flash[:notice] = @user_application.errors.full_messages.join(", ")
      redirect_to new_user_application_path
    end
  end

  def edit
    @user_application = UserApplication.find(params[:id])
    @user = User.find_by(admin_id: current_admin.id)
    @access_accepted = @user.level == 1
  end

  def update
    @user_application = UserApplication.find(params[:id])
    @user = User.find_by(admin_id: current_admin.id)

    app_params = @user.level == 0 ? user_params : officer_params
    
    if @user_application.update(app_params)
      redirect_to user_application_path(@user_application.id)
    else
      redirect_to edit_user_application_path(@user_application)
    end
  
  end

  def delete
    @user_application = UserApplication.find(params[:id])
  end

  def destroy
    @user_application = UserApplication.find(params[:id])
    @user = User.find_by(admin_id: current_admin.id)
    @user_application.destroy
    if @user.level == 0
      redirect_to user_application_path(@user_application.id)
    elsif @user.level == 1
      redirect_to user_applications_path
    end
  end

  private
  def user_params
    params.require(:user_application).permit(
      :child_name, 
      :child_birthdate,
      :primary_diagnosis,
      :secondary_diagnosis,
      :adaptive_equipment,
      :child_height,
      :child_weight,
      :caregiver_name,
      :caregiver_email,
      :caregiver_phone,
      :can_transport,
      :can_store,
      :notes)
  end

  def officer_params
    params.require(:user_application).permit(
      :child_name, 
      :child_birthdate,
      :primary_diagnosis,
      :secondary_diagnosis,
      :adaptive_equipment,
      :child_height,
      :child_weight,
      :caregiver_name,
      :caregiver_email,
      :caregiver_phone,
      :can_transport,
      :can_store,
      :notes,
      :accepted)
  end
end
