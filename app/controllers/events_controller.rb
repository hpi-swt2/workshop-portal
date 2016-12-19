require 'pdf_generation/badges_pdf'
require 'pdf_generation/applications_pdf'

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :print_applications]

  # GET /events
  def index
    @events = Event.draft_is false
  end

  # GET /events/1
  def show
    @free_places = @event.compute_free_places
    @occupied_places = @event.compute_occupied_places
    @application_letters = filter_application_letters(@event.application_letters)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    @event.draft = (params[:draft] != nil)

    if @event.save
      redirect_to @event, notice: I18n.t('.events.notices.created')
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    attrs = event_params

    @event.draft = (params[:commit] == "draft")

    if @event.update(attrs)
      redirect_to @event, notice: I18n.t('events.notices.updated')
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: I18n.t('events.notices.destroyed')
  end

  # GET /events/1/badges
  def badges
    @event = Event.find(params[:event_id])
    @participants = @event.participants
  end

  # POST /events/1/badges
  def print_badges
    @event = Event.find(params[:event_id])
    name_format = params[:name_format]
    show_color = params[:show_color]
    show_organization = params[:show_organization]
    logo = params[:logo_upload]

    participant_ids = params.select { |key, value| key.include? "_print" }.values
    participants = User.where(id: participant_ids)
    # remove users who are not actual participants
    participants &= @event.participants
    begin
      pdf = BadgesPDF.generate(@event, participants, name_format, show_color, show_organization, logo)
      send_data pdf, filename: "badges.pdf", type: "application/pdf", disposition: "inline"
    rescue Prawn::Errors::UnsupportedImageType
      @event.errors.add(:base, "Logo must be image")
      @participants = @event.participants
      render 'badges'
    end
  end

  # GET /events/1/participants
  def participants
    @event = Event.find(params[:id])
    @participants = @event.participants_by_agreement_letter
  end

  # GET /events/1/print_applications
  def print_applications
    authorize! :print_applications, @event
    pdf = ApplicationsPDF.generate(@event)
    send_data pdf, filename: "applications_#{@event.name}_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
  end
  # GET /events/1/send-acceptances-email
  def send_acceptance_emails
    event = Event.find(params[:id])
    @email = event.generate_acceptances_email
    @templates = [{subject: 'Zusage 1', content: 'Lorem Ispum...'}, {subject: 'Zusage 2', content: 'Lorem Ispum...'}, {subject: 'Zusage 3', content: 'Lorem Ispum...'}]
    render :email
  end

  # GET /events/1/send-rejections-email
  def send_rejection_emails
    event = Event.find(params[:id])
    @email = event.generate_rejections_email
    @templates = [{subject: 'Absage 1', content: 'Lorem Ispum...'}, {subject: 'Absage 2', content: 'Lorem Ispum...'}, {subject: 'Absage 3', content: 'Lorem Ispum...'}]
    render :email
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :description, :max_participants, :kind, :organizer, :knowledge_level, :application_deadline, date_ranges_attributes: [:start_date, :end_date, :id])
    end

    def filter_application_letters(application_letters)
      application_letters = application_letters.to_a
      filters = (params[:filter] || {}).select { |k, v| v == '1' }.map{ |k, v| k.to_s }
      if filters.count > 0  # skip filtering if no filters have been set
        application_letters.keep_if { |l| filters.include?(l.status) }
      end
      application_letters
    end
end
