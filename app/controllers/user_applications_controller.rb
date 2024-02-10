class UserApplicationsController < ApplicationController
  def show
    @user_application = UserApplication.find(params[:id])
  end

  def new
    @user_application = UserApplication.new()
  end

  def create
    @user_application = UserApplication.new(app_params)
    params[:user_application][:caregiver_phone].gsub!(/\D/, '')
    if @user_application.save
      redirect_to user_application_path(@user_application)
    else
      flash[:notice] = @user_application.errors.full_messages.join(", ")
      redirect_to new_user_application_path
    end
  end

  def edit
    @user_application = UserApplication.find(params[:id])
  end

  def update
    @user_application = UserApplication.find(params[:id])
    if @user_application.update(app_params)
      redirect_to user_application_path(@user_application)
    else
      redirect_to edit_user_application_path(@user_application)
    end
  end

  def delete
    @user_application = UserApplication.find(params[:id])
  end

  def destroy
    @user_application = UserApplication.find(params[:id])
    @user_application.destroy
    redirect_to main_index_path
  end

  private
  def app_params
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
end
