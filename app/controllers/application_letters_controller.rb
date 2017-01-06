class ApplicationLettersController < ApplicationController
  load_and_authorize_resource param_method: :application_params
  skip_authorize_resource :only => :new

  before_action :set_application, only: [:show, :edit, :update, :destroy, :check]

  # GET /applications
  def index
    @application_letters = ApplicationLetter.where(user_id: current_user.id)
  end

  # GET /applications/1
  def show
    @application_note = ApplicationNote.new
  end

  # GET /applications/new
  def new
    if not current_user
      message = I18n.t('application_letters.login_before_creation')
      return redirect_to user_session_path, :alert => message
    elsif not current_user.profile.present?
      message = I18n.t('application_letters.fill_in_profile_before_creation')
      flash[:event_id] = params[:event_id]
      flash.keep(:event_id)
      return redirect_to new_profile_path, :alert => message
    end
    @application_letter = ApplicationLetter.new
    authorize! :new, @application_letter
  end

  # GET /applications/1/check
  def check
    @application_deadline_exceeded = @application_letter.after_deadline?
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
      redirect_to check_application_letter_path(@application_letter), notice: I18n.t('application_letters.successful_create')
    else
      render :new
    end
  end

  # PATCH/PUT /applications/1
  def update
    if @application_letter.update_attributes(application_params)
      redirect_to check_application_letter_path(@application_letter), notice: I18n.t('application_letters.successful_update')
    else
      render :edit
    end
  end

  # PATCH/PUT /applications/1/status
  def update_status
    if @application_letter.update_attributes(application_status_param)
      redirect_to :back, notice: I18n.t('application_letters.successful_update') rescue ActionController::RedirectBackError redirect_to root_path
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
      params.require(:application_letter).permit(:grade, :experience, :motivation, :coding_skills, :emergency_number, :vegeterian, :vegan, :allergic, :allergies, :user_id, :event_id)
    end

    # Only allow to update the status
    def application_status_param
      params.require(:application_letter).permit(:status)
    end
end
