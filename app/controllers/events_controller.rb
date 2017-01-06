require 'pdf_generation/applications_pdf'

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :print_applications]

  # GET /events
  def index
    @events = Event.sorted_by_start_date(!can?(:edit, Event)).reverse
  end

  # GET /events/1
  def show
    @free_places = @event.compute_free_places
    @occupied_places = @event.compute_occupied_places
    @application_letters = filter_application_letters(@event.application_letters)
    @material_files = get_material_files(@event)
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
    names = badges_name_params

    # pdf document initialization
    pdf = Prawn::Document.new(:page_size => 'A4')
    pdf.stroke_color "000000"

    # divide in pieces of 10 names
    badge_pages = names.each_slice(10).to_a
    badge_pages.each_with_index do | page, index |
      create_badge_page(pdf, page, index)
    end


    send_data pdf.render, filename: "badges.pdf", type: "application/pdf", disposition: "inline"
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
    event.lock_application_status
    @email = event.generate_acceptances_email
    @templates = [{subject: 'Zusage 1', content: 'Lorem Ispum...'}, {subject: 'Zusage 2', content: 'Lorem Ispum...'}, {subject: 'Zusage 3', content: 'Lorem Ispum...'}]
    render :email
  end

  # GET /events/1/send-rejections-email
  def send_rejection_emails
    event = Event.find(params[:id])
    event.lock_application_status
    @email = event.generate_rejections_email
    @templates = [{subject: 'Absage 1', content: 'Lorem Ispum...'}, {subject: 'Absage 2', content: 'Lorem Ispum...'}, {subject: 'Absage 3', content: 'Lorem Ispum...'}]
    render :email
  end

  # POST /events/1/upload_material
  def upload_material
    event = Event.find(params[:event_id])
    material_path = event.material_path
    Dir.mkdir(material_path) unless File.exists?(material_path)

    file = params[:file_upload]
    unless is_file?(file)
      redirect_to event_path(event), alert: t("events.material_area.no_file_given")
      return false
    end
    begin
      File.write(File.join(material_path, file.original_filename), file.read, mode: "wb")
    rescue IOError
      redirect_to event_path(event), alert: I18n.t("events.material_area.saving_fails")
      return false
    end
    redirect_to event_path(event), notice: I18n.t("events.material_area.success_message")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:name, :description, :max_participants, :kind, :organizer, :knowledge_level, :application_deadline, date_ranges_attributes: [:start_date, :end_date, :id])
    end

    # Generate all names to print from the query-params
    #
    # @return participant_names as array of strings
    def badges_name_params
      params.select { |key, value| key.include? "_print" }.values
    end

    # Create a name badge in a given pdf
    #
    # @param pdf, is a prawn pdf-object
    # @param name [String] is the name label of the new badge
    # @param x [Integer] is the x-coordinate of the upper left corner of the new badge
    # @param y [Integer] is the y-coordinate of the upper left corner of the new badge
    def create_badge(pdf, name, x, y)
      width = 260
      height = 150

      pdf.stroke_rectangle [x, y], width, height
      pdf.text_box name, :at => [x + width / 2 - 50 , y - 20], :width => width - 100, :height => height - 100, :overflow => :shrink_to_fit
    end

    def filter_application_letters(application_letters)
      application_letters = application_letters.to_a
      filters = (params[:filter] || {}).select { |k, v| v == '1' }.map{ |k, v| k.to_s }
      if filters.count > 0  # skip filtering if no filters have been set
        application_letters.keep_if { |l| filters.include?(l.status) }
      end
      application_letters
    end

    # Create a page with maximum 10 badges
    #
    # @param pdf, is a prawn pdf-object
    # @param names [Array of Strings] are the name which are printed to the badges
    # @param index [Number] the page number
    def create_badge_page(pdf, names, index)
      # create no pagebreak for first page
      pdf.start_new_page if index > 0

      names.each_slice(2).with_index do |(left, right), row|
        create_badge(pdf, left, 0, 750 - row * 150)
        create_badge(pdf, right, 260, 750 - row * 150) unless right.nil?
      end
    end

    # Checks if a file is valid and not empty
    #
    # @param [ActionDispatch::Http::UploadedFile] is a file object
    # @return [Boolean] whether @file is a valid file
    def is_file?(file)
      file.respond_to?(:open) && file.respond_to?(:content_type) && file.respond_to?(:size)
    end

    # Gets all file names stored in the material storage of the event
    #
    # @param [Event]
    # @return [Array of Strings]
    def get_material_files(event)
      material_path = event.material_path
      File.exists?(material_path) ? Dir.glob(File.join(material_path, "*")) : []
    end
end
