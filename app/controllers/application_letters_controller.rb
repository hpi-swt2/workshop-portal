class ApplicationLettersController < ApplicationController
  before_action :set_application, only: [:show, :edit, :update, :destroy]

  # GET /applications
  def index
    @application_letters = ApplicationLetter.all
  end

  # GET /applications/1
  def show
  end

  # GET /applications/new
  def new
    @application_letter = ApplicationLetter.new
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications
  def create
    @application_letter = ApplicationLetter.new(application_params)
		#workshop_id must be param to new_application_letter_path
		if params[:workshop_id]
			@application_letter.workshop_id = params[:workshop_id]
		end

    if @application_letter.save
      redirect_to @application_letter, notice: 'Application was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /applications/1
  def update
    if @application_letter.update(application_params)
      redirect_to @application_letter, notice: 'Application was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /applications/1
  def destroy
    @application_letter.destroy
    redirect_to application_letters_url, notice: 'Application was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application_letter = ApplicationLetter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def application_params
      params.require(:application_letter).permit(:grade, :experience, :motivation, :coding_skills, :emergency_number, :vegeterian, :vegan, :allergic, :allergies, :user_id, :workshop_id)
    end
end
