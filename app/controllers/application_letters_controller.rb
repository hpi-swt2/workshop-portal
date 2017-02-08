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
    @has_free_places = @application_letter.event.compute_free_places > 0
  end

  # GET /applications/new
  def new
    if not current_user
      message = I18n.t('application_letters.login_before_creation')
      flash[:event_id] = params[:event_id]
      flash.keep(:event_id)
      return redirect_to user_session_path, :alert => message
    elsif not current_user.profile.present?
      message = I18n.t('application_letters.fill_in_profile_before_creation')
      flash[:event_id] = params[:event_id]
      flash.keep(:event_id)
      return redirect_to new_profile_path, :alert => message
    end

    @application_letter = ApplicationLetter.new
    last_application_letter = ApplicationLetter.where(user: current_user).order("created_at").last
    if last_application_letter
      attrs_to_fill_in = last_application_letter.attributes
        .slice("emergency_number", "vegetarian", "vegan", "allergies")
      @application_letter.attributes = attrs_to_fill_in
      flash.now[:notice] = I18n.t('application_letters.fields_filled_in')
    end
    authorize! :new, @application_letter
    if params[:event_id]
      @application_letter.event_id = params[:event_id]
      @event = Event.find(params[:event_id])
      if @event.hidden
        @submit_button_text = t('application_letters.helpers.submit.create')
      end
    end
  end

  # GET /applications/1/check
  def check
    @application_deadline_exceeded = @application_letter.after_deadline?
    flash[:application_id] = params[:id]
    flash.keep(:application_id)
  end

  # GET /applications/1/edit
  def edit
    @application_letter = ApplicationLetter.find(params[:id])
    @event = Event.find(@application_letter.event_id)
    if @event.hidden
      @submit_button_text = t('application_letters.helpers.submit.update')
    end
  end

  # POST /applications
  def create
    @application_letter = ApplicationLetter.new(application_params)
    #event must be param to new_application_letter_path
    seminar_name = ''
    if params[:event_id]
      @application_letter.event_id = params[:event_id]
      seminar_name = Event.find(params[:event_id]).name
    end
    @application_letter.user_id = current_user.id
    @event = Event.find(@application_letter.event_id)
    if @event.hidden
      @submit_button_text = t('application_letters.helpers.submit.create')
    end

    # Send Confirmation E-Mail
    email_params = {
        :hide_recipients => true,
        :recipients => current_user.email,
        :reply_to => Rails.configuration.reply_to_address,
        :subject => I18n.t('controllers.application_letters.confirmation_mail.subject'),
        :content => I18n.t("controllers.application_letters.confirmation_mail.content_#{current_user.profile.gender}",
                           :seminar_name => seminar_name,
                           :first_name => current_user.profile.first_name,
                           :last_name => current_user.profile.last_name,
                           :event_link => application_letters_url)
    }
    @email = Email.new(email_params)
    Mailer.send_generic_email(@email.hide_recipients, @email.recipients, @email.reply_to, @email.subject, @email.content)

    if @application_letter.save
      redirect_to check_application_letter_path(@application_letter), notice: I18n.t('application_letters.successful_creation')
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
    if @application_letter.update_attributes(application_status_param.merge(status_notification_sent: false))
      if request.xhr?
        render json: {
          free_places: I18n.t('events.applicants_overview.free_places',
                              count: @application_letter.event.compute_free_places),
          occupied_places: I18n.t('events.applicants_overview.occupied_places',
                                  count: @application_letter.event.compute_occupied_places),
          mail_tooltip: @application_letter.event.send_mails_tooltip
        }
      else
        redirect_to :back, notice: I18n.t('application_letters.successful_update') rescue ActionController::RedirectBackError redirect_to root_path
      end
    else
      render :edit
    end
  end

  # DELETE /applications/1
  def destroy
    @application_letter.destroy
    redirect_to application_letters_url, notice: I18n.t('application_letters.successful_deletion')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application_letter = ApplicationLetter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    # Don't allow user_id as you shouldn't be able to set the user from outside of create/update.
    def application_params
      params.require(:application_letter).permit(:motivation, :emergency_number, :organisation,
                                                 :vegetarian, :vegan, :allergies, :annotation, :user_id, :event_id)
      .merge({:custom_application_fields => params[:custom_application_fields]})
    end

    # Only allow to update the status
    def application_status_param
      params.require(:application_letter).permit(:status)
    end
end
