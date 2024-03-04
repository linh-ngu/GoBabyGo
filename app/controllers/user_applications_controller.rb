class UserApplicationsController < ApplicationController
  before_action :require_admin

  def require_admin
    unless admin_signed_in?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
  end

  def index
    @user = User.find_by(admin_id: current_admin.id)
    @page_title = @user.visitor? || @user.applicant? ? "Your Applications" : "All User Applications"
    
    # Filtering based on user role
    if @user.visitor? || @user.applicant?
      @user_applications = UserApplication.where(user_id: @user.id)
    elsif @user.officer_member?
      @not_accepted_user_applications = UserApplication.where(accepted: [nil, false], waitlist: false)
      @waitlist_user_applications = UserApplication.where(waitlist: true, accepted: false)
      @accepted_user_applications = UserApplication.where(accepted: true)
      
      #different options for sorting applications
      sorting_option = case params[:sort_option]
      when "created_at_asc"
        :asc
      when "created_at_desc"
        :desc
      else
        :asc # Default sorting option
      end

      # Apply sorting to user applications
      @not_accepted_user_applications = @not_accepted_user_applications.order(created_at: sorting_option)
      @waitlist_user_applications = @waitlist_user_applications.order(created_at: sorting_option)
      @accepted_user_applications = @accepted_user_applications.order(created_at: sorting_option)




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
      if params[:start_date].present? || params[:end_date].present?
        begin
          start_date = params[:start_date].present? ? Date.parse(params[:start_date]).beginning_of_day : nil
          end_date = params[:end_date].present? ? Date.parse(params[:end_date]).end_of_day : nil
        rescue ArgumentError => e
          flash[:error] = "Invalid date format (MM-DD-YYYY)."
          redirect_to user_applications_path
        end

        if start_date.present? && end_date.present?
          if start_date > end_date
            @date_range_error = "Start date cannot be later than end date."
            return
          end
        end
        
        if start_date && end_date
          @not_accepted_user_applications = @not_accepted_user_applications.where(created_at: start_date..end_date)
          @waitlist_user_applications = @waitlist_user_applications.where(created_at: start_date..end_date)
          @accepted_user_applications = @accepted_user_applications.where(created_at: start_date..end_date)
        elsif start_date
          @not_accepted_user_applications = @not_accepted_user_applications.where("created_at >= ?", start_date)
          @waitlist_user_applications = @waitlist_user_applications.where("created_at >= ?", start_date)
          @accepted_user_applications = @accepted_user_applications.where("created_at >= ?", start_date)
        elsif end_date
          @not_accepted_user_applications = @not_accepted_user_applications.where("created_at <= ?", end_date)
          @waitlist_user_applications = @waitlist_user_applications.where("created_at <= ?", end_date)
          @accepted_user_applications = @accepted_user_applications.where("created_at <= ?", end_date)
        end
      end

      # Applying height range filter
      if params[:min_height].present? || params[:max_height].present?
        begin
          min_height = params[:min_height].to_i
          max_height = params[:max_height].to_i
        rescue ArgumentError => e
          flash[:error] = "Height must be a number."
          return
        end

        if (min_height.present? && min_height < 0) || (max_height.present? && max_height < 0)
          @height_value_error = "Height cannot be negative."
          return
        end

        if min_height.present? && max_height.present?
          if min_height > max_height
            @height_range_error = "Minimum height cannot be greater than maximum height."
            return
          end
        end
      
        if min_height && max_height
          @not_accepted_user_applications = @not_accepted_user_applications.where(child_height: min_height..max_height)
          @waitlist_user_applications = @waitlist_user_applications.where(child_height: min_height..max_height)
          @accepted_user_applications = @accepted_user_applications.where(child_height: min_height..max_height)
        elsif min_height
          @not_accepted_user_applications = @not_accepted_user_applications.where("child_height >= ?", min_height)
          @waitlist_user_applications = @waitlist_user_applications.where("child_height >= ?", min_height)
          @accepted_user_applications = @accepted_user_applications.where("child_height >= ?", min_height)
        elsif max_height
          @not_accepted_user_applications = @not_accepted_user_applications.where("child_height <= ?", max_height)
          @waitlist_user_applications = @waitlist_user_applications.where("child_height <= ?", max_height)
          @accepted_user_applications = @accepted_user_applications.where("child_height <= ?", max_height)
        end
      end
    end
  end
  
  def show
    @user = User.find_by(admin_id: current_admin.id)
    @user_application = UserApplication.find(params[:id])
    
    if @user.applicant? || @user.visitor?  
      if @user.id != @user_application.user_id
        redirect_to root_path
        flash[:notice] = "You do not have permission to view that page!"
      end
    end
  end

  def new
    @user_application = UserApplication.new()
  end

  def create
    @user = User.find_by(admin_id: current_admin.id)

    if @user.visitor? || @user.applicant?
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
      if @user.visitor?
        @user.update(level: :applicant)
      end
      redirect_to user_application_path(@user_application.id)
    else
      flash[:notice] = @user_application.errors.full_messages.join(", ")
      redirect_to new_user_application_path
    end
  end

  def edit
    @user_application = UserApplication.find(params[:id])
    @user = User.find_by(admin_id: current_admin.id)
    if @user.applicant? || @user.visitor? || @user == nil
      if @user.id != @user_application.user_id || @user == nil
        redirect_to root_path
        flash[:notice] = "You do not have permission to view that page!"
      end
    end
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
      flash[:notice] = "There was an error when updating the application."
    end
  end

  def delete
    @user = User.find_by(admin_id: current_admin.id)
    @user_application = UserApplication.find(params[:id])
    if @user.applicant? || @user.visitor? || @user == nil
      if @user.id != @user_application.user_id || @user == nil
        redirect_to root_path
        flash[:notice] = "You do not have permission to view that page!"
      end
    end
  end

  def destroy
    @user = User.find_by(admin_id: current_admin.id)
    @user_application = UserApplication.find(params[:id])
    @user_application.application_notes.destroy_all
    @user_application.destroy
    redirect_to user_applications_path(@user)
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
