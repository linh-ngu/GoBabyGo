class PartsController < ApplicationController
    before_action :set_part, only: %i[ show edit update destroy ]

    before_action :check_role

    def check_role
      @current_user = User.find_by(admin_id: current_admin.id)

      unless @current_user.admin? || @current_user.officer_member? || @current_user.staff_member?
        redirect_to root_path
        flash[:notice] = "You do not have permission to view that page!"
      end
    end

    # GET /parts or /parts.json
    def index
      @current_user = User.find_by(admin_id: current_admin.id)
      # unless @current_user.admin? || @current_user.officer_member?
      #   redirect_to root_path
      #   flash[:notice] = "You do not have permission to view that page!"
      # end
      @parts = Part.all
    end

    # GET /parts/1 or /parts/1.json
    def show
      @current_user = User.find_by(admin_id: current_admin.id)
      # unless @current_user.admin? || @current_user.officer_member?
      #   redirect_to root_path
      #   flash[:notice] = "You do not have permission to view that page!"
      # end
    end

    # # GET /parts/new
    # def new
    #   @current_user = User.find_by(admin_id: current_admin.id)
    #   # unless @current_user.admin? || @current_user.officer_member?
    #   #   redirect_to root_path
    #   #   flash[:notice] = "You do not have permission to view that page!"
    #   # end
    #   @part = Part.new
    # end

    # GET /parts/1/edit
    def edit
      @current_user = User.find_by(admin_id: current_admin.id)
      unless @current_user.admin? || @current_user.officer_member?
        redirect_to root_path
        flash[:notice] = "You do not have permission to view that page!"
      end
    end

    # POST /parts or /parts.json
    def create
      @current_user = User.find_by(admin_id: current_admin.id)
      # unless @current_user.admin? || @current_user.officer_member?
      #   redirect_to root_path
      #   flash[:notice] = "You do not have permission to view that page!"
      # end
      # Find the car
      # puts "Params received: #{params.inspect}"
      c = Car.find(params[:part][:car_id])
      # Create a new part associated with the car
      @part = c.parts.build(part_params)


      respond_to do |format|
        if @part.save
          c.parts << @part
          format.html { redirect_to car_url(c), notice: "part was successfully created." }
          format.json { render :show, status: :created, location: @part }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @part.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /parts/1 or /parts/1.json
    def update
      @current_user = User.find_by(admin_id: current_admin.id)
      # unless @current_user.admin? || @current_user.officer_member?
      #   redirect_to root_path
      #   flash[:notice] = "You do not have permission to view that page!"
      # end
      respond_to do |format|
        if @part.update(part_params)
          format.html { redirect_to part_url(@part), notice: "part was successfully updated." }
          format.json { render :show, status: :ok, location: @part }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @part.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /parts/1 or /parts/1.json
    def destroy
      @current_user = User.find_by(admin_id: current_admin.id)
      # unless @current_user.admin? || @current_user.officer_member?
      #   redirect_to root_path
      #   flash[:notice] = "You do not have permission to view that page!"
      # end
      c = @part.car_id
      @part.destroy

      respond_to do |format|
        format.html { redirect_to car_url(c), notice: "part was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_part
        @part = Part.find(params[:id])
      end
      def part_params
        params.require(:part).permit(:part_name, :part_price, :purchase_source, :quantity_purchased, :car_id)
      end
  end
