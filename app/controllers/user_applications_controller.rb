class UserApplicationsController < ApplicationController
  def index
    @user = User.find_by(admin_id: current_admin.id)
    @page_title = @user.visitor? ? "Your Applications" : "All User Applications"
    
    # Filtering based on user role
    if @user.visitor?
      @user_applications = UserApplication.where(user_id: @user.id)
    elsif @user.officer_member?
      @not_accepted_user_applications = UserApplication.where(accepted: [nil, false], waitlist: false)
      @waitlist_user_applications = UserApplication.where(waitlist: true, accepted: false)
      @accepted_user_applications = UserApplication.where(accepted: true)
  
      # Additional filtering based on user selection
      if params[:accepted] == "1"
        @not_accepted_user_applications = []
        @waitlist_user_applications = []
      elsif params[:waitlist] == "1"
        @not_accepted_user_applications = []
        @accepted_user_applications = []
      elsif params[:not_accepted] == "1"
        @waitlist_user_applications = []
        @accepted_user_applications = []
      end
      
      # Applying date range filter
      if params[:start_date].present? && params[:end_date].present?
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        @not_accepted_user_applications = @not_accepted_user_applications.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
        @waitlist_user_applications = @waitlist_user_applications.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
        @accepted_user_applications = @accepted_user_applications.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      end
      
      # Applying height range filter
      if params[:min_height].present? && params[:max_height].present?
        min_height = params[:min_height].to_i
        max_height = params[:max_height].to_i
        @not_accepted_user_applications = @not_accepted_user_applications.where(child_height: min_height..max_height)
        @waitlist_user_applications = @waitlist_user_applications.where(child_height: min_height..max_height)
        @accepted_user_applications = @accepted_user_applications.where(child_height: min_height..max_height)
      end
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

    if @user.visitor?
      #user from website submits application
      @user_application = UserApplication.new(user_params)
      flash[:notice] = "Application submitted successfully. We will reach out to you soon with our response."
    elsif @user.officer_member?
      #officer submits application
      @user_application = UserApplication.new(officer_params)
      flash[:notice] = "Application submitted successfully."
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
    #if user is an officer, access to edit accepted
    @access_accepted = @user.officer_member?
  end

  def update
    @user_application = UserApplication.find(params[:id])
    @user = User.find_by(admin_id: current_admin.id)

    #app_params passed based on visitor/officer role status - not including application role
    app_params = @user.visitor? ? user_params : officer_params

    if @user_application.update(app_params)
      redirect_to user_application_path(@user_application.id)
      flash[:notice] = "Application updated successfully."
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
    # if @user.level == 0
    # instead of above line, if user is visitor redirect_to
    if @user.visitor?
      redirect_to user_application_path(@user_application.id)
    # elsif @user.level == 1
    elsif @user.officer_member?
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
      :accepted,
      :waitlist)
  end
end
