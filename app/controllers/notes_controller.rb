class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
    @current_user = User.find_by(admin_id: current_admin.id)
    @edit_access = @current_user.id == @note.user_id || @current_user.admin?
    if !@edit_access
      redirect_to root_path
      flash[:notice] = "You do not have permission to view that page!"
    end
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to car_url(@note.car_id), notice: "Note was successfully created." }
      else
        format.html { redirect_to car_url(@note.car_id), notice: "Content can\'t be blank" }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    car_id = @note.car_id
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to car_url(car_id), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    car_id = @note.car_id
    
    @current_user = User.find_by(admin_id: current_admin.id)
    @edit_access = @current_user.id == @note.user_id || @current_user.admin?
    if !@edit_access
      format.html { redirect_to car_path(car_id), notice: "Not allowed to destroy that!" }
      format.json { head :no_content }
    end
    @note.destroy

    respond_to do |format|
      format.html { redirect_to car_path(car_id), notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:content, :user_id, :car_id)
    end
end
