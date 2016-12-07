class ApplicationLettersController < ApplicationController
  load_and_authorize_resource param_method: :application_params
  skip_authorize_resource :only => :new

  before_action :set_application, only: [:show, :edit, :update, :destroy]

  # GET /applications
  def index
    @application_letters = ApplicationLetter.all
  end

  # GET /applications/1
  def show
    @application_note = ApplicationNote.new
  end

  # GET /applications/new
  def new
    @application_letter = ApplicationLetter.new
    authorize! :new, @application_letter, :message => I18n.t('application_letters.login_before_creation')
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications
  def create
    @application_letter = ApplicationLetter.new(application_params)
    #event must be param to new_application_letter_path
    if params[:event_id]
      @application_letter.event_id = params[:event_id]
    end
    @application_letter.user_id = current_user.id

    if @application_letter.save
      redirect_to @application_letter, notice: 'Application was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /applications/1
  def update
    if @application_letter.update_attributes(application_params)
      redirect_to :back, notice: 'Application was successfully updated.' rescue ActionController::RedirectBackError redirect_to root_path
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
    # Don't allow user_id as you shouldn't be able to set the user from outside of create/update.
    def application_params
      params.require(:application_letter).permit(:grade, :experience, :motivation, :coding_skills, :emergency_number, :vegeterian, :vegan, :allergic, :allergies, :user_id, :event_id, :status)
    end
end
