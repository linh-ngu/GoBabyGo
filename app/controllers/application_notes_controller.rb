class ApplicationNotesController < ApplicationController
  before_action :set_user_application
  before_action :set_application_note, only: %i[ show edit update destroy ]

  # GET /application_notes or /application_notes.json
  def index
    # @application_notes = ApplicationNote.all
    @application_notes = @user_application.application_notes
  end

  # GET /application_notes/1 or /application_notes/1.json
  def show
    @application_note = ApplicationNote.find_by_id(params[:id])
  end

  # GET /application_notes/new
  def new
    # @application_note = ApplicationNote.new
    @application_note = @user_application.application_notes.build
    # @application_note = @user_application.application_notes.new
  end

  # GET /application_notes/1/edit
  def edit
    @application_note = ApplicationNote.find_by_id(params[:id])
  end

  # POST /application_notes or /application_notes.json
  def create
    # @application_note = ApplicationNote.new(application_note_params)
    # @application_note = @user_application.application_notes.new(application_note_params)
    @application_note = @user_application.application_notes.build(application_note_params)

    respond_to do |format|
      if @application_note.save
        format.html { redirect_to [@user_application, @application_note], notice: "Application note was successfully created." }
        format.json { render :show, status: :created, location: @application_note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_notes/1 or /application_notes/1.json
  def update
    respond_to do |format|
      if @application_note.update(application_note_params)
        format.html { redirect_to [@user_application, @application_note], notice: "Application note was successfully updated." }
        format.json { render :show, status: :ok, location: @application_note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_notes/1 or /application_notes/1.json
  def destroy
    @application_note.destroy

    respond_to do |format|
      format.html { redirect_to [@user_application, @application_note], notice: "Application note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_application
      @user_application = UserApplication.find_by_id(params[:user_application_id])
    end

    def set_application_note
      @application_note = ApplicationNote.find_by_id(params[:id])
    
      if @application_note.nil?
        redirect_to application_notes_path
      end
    end

    # Only allow a list of trusted parameters through.
    def application_note_params
      params.require(:application_note).permit(:content)
    end
end
