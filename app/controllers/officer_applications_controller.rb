class OfficerApplicationsController < ApplicationController
  def index
    @user_applications = UserApplication.order(:child_name)
  end
  
  def show
    @user_application = UserApplication.find(params[:id])
  end

  def edit
    @user_application = UserApplication.find(params[:id])
  end

  def update
    @user_application = UserApplication.find(params[:id])
    if @user_application.update(officer_params)
      redirect_to officer_applications_path
    else
      render('new')
    end
  end

  def delete
    @user_application = UserApplication.find(params[:id])
  end

  def destroy
    @user_application = UserApplication.find(params[:id])
    @user_application.destroy
    redirect_to officer_applications_path
  end

  private
  def officer_params
    params.require(:user_application).permit(
      :child_name, 
      :child_birthdate,
      :primary_diagnosis,
      :child_height,
      :child_weight,
      :caregiver_name,
      :caregiver_email,
      :caregiver_phone,
      :can_transport,
      :can_store,
      :accepted)
  end
end
