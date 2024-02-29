class CarsController < ApplicationController
  before_action :set_car, only: %i[ show edit update destroy ]

  # GET /cars or /cars.json
  def index
    @current_user = User.find_by(admin_id: current_admin.id)
    if @current_user.admin?
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
    @edit_access = @current_user.admin?
    @car = Car.includes(:parts).find(params[:id])
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
    @part = Part.new
  end

  # POST /cars or /cars.json
  def create
    car_type = CarType.find(params[:car][:car_type_id])
    total_expense = car_type.price

    # Create Finance object first
    @finance = Finance.new(total_expense: total_expense)
    
    # Associate finance with the car
    @car = Car.new(car_params)
    @car.finance = @finance

    respond_to do |format|
      if @car.save
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
    @car.destroy

    respond_to do |format|
      format.html { redirect_to cars_url, notice: "car was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end
    def car_params
      params.require(:car).permit(:car_type_id, :modification_details, :complete, :user_application_id)
    end
end
  