class CarTypesController < ApplicationController
  before_action :set_car_type, only: %i[ show edit update destroy ]

  # GET /car_types or /car_types.json
  def index
    
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    @car_types = CarType.all
  end

  # GET /car_types/1 or /car_types/1.json
  def show
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
  end

  # GET /car_types/new
  def new
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    @car_type = CarType.new
  end

  # GET /car_types/1/edit
  def edit
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
  end

  # POST /car_types or /car_types.json
  def create
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    @car_type = CarType.new(car_type_params)

    respond_to do |format|
      if @car_type.save
        format.html { redirect_to car_type_url(@car_type), notice: "car_type was successfully created." }
        format.json { render :show, status: :created, location: @car_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_types/1 or /car_types/1.json
  def update
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    respond_to do |format|
      if @car_type.update(car_type_params)
        format.html { redirect_to car_type_url(@car_type), notice: "car_type was successfully updated." }
        format.json { render :show, status: :ok, location: @car_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_types/1 or /car_types/1.json
  def destroy
    @current_user = User.find_by(admin_id: current_admin.id)
    unless @current_user.admin? || @current_user.officer_member?
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
    @car_type.destroy

    respond_to do |format|
      format.html { redirect_to car_types_url, notice: "car_type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_type
      @car_type = CarType.find(params[:id])
    end
    def car_type_params
      params.require(:car_type).permit(:name, :max_height, :min_height, :price)
    end
end
    