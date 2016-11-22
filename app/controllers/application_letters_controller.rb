class ApplicationLettersController < ApplicationController
  load_and_authorize_resource param_method: :application_params

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
    @application_letter.user_id = current_user.id

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
      params.require(:application_letter).permit(:motivation, :user_id, :workshop_id, :status)
    end
end
