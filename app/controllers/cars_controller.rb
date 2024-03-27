class CarsController < ApplicationController
  before_action :set_car, only: %i[ show edit update destroy new_part ]

  # GET /cars or /cars.json
  def index
    @current_user = User.find_by(admin_id: current_admin.id)
    if @current_user.admin? || @current_user.officer_member?
      @cars = Car.all
      @edit_access = true
    else
      @cars = Car.joins(:user_application).where(user_applications: { user_id: @current_user.id })
      @edit_access = false
    end
  end

  # GET /cars/1 or /cars/1.json
  def show
    @current_user = User.find_by(admin_id: current_admin.id)
    @edit_access = @current_user.admin? || @current_user.officer_member?
    @car = Car.includes(:parts).find(params[:id])
    if @car.user_application_id.present?
      unless @current_user.admin? || @current_user.officer_member? || @car.user_application.user_id == @current_user.id
        redirect_to root_path
        flash[:notice] = "You do not have permission to view that page!"
      end
    else
      unless @current_user.admin? || @current_user.officer_member?
        redirect_to root_path
        flash[:notice] = "You do not have permission to view that page!"
      end
    end
  end

  # GET /cars/new
  def new
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    @part = Part.new
  end

  # POST /cars or /cars.json
  def create
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end

    @car = Car.new(car_params)

    respond_to do |format|
      if @car.save
        # car_type = CarType.find(params[:car][:car_type_id])
        # total_expense = car_type.price

        # @car.finance = @finance

        # Create Finance object first
        # @finance = Finance.new(total_expense: total_expense)
        format.html { redirect_to car_url(@car), notice: "car was successfully created." }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1 or /cars/1.json
  def update
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to car_url(@car), notice: "car was successfully updated." }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1 or /cars/1.json
  def destroy
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    for part in @car.parts
      part.destroy
    end
    @car.destroy

    respond_to do |format|
      format.html { redirect_to cars_url, notice: "car was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def new_part
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    @part = Part.new
  end    

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end
    def car_params
      params.require(:car).permit(:modification_details, :complete, :user_application_id, :car_type_id)
    end
    def part_params
      params.require(:part).permit(:part_name, :part_price, :purchase_source, :quantity_purchased, :car_id)
    end
end
