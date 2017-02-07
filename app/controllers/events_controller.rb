require 'pdf_generation/badges_pdf'
require 'pdf_generation/applications_pdf'
require 'pdf_generation/participants_pdf'
require 'rubygems'
require 'zip'
require 'carrierwave'

class EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update, :destroy, :participants, 
    :participants_pdf, :print_applications, :print_applications_eating_habits, :badges, :print_badges]


  # GET /events
  def index
    @events = add_event_query_conditions(Event.future)
  end

  def archive
    @events = add_event_query_conditions(Event.past)
  end

  # GET /events/1
  def show
    if @event.hidden and !can? :view_hidden, Event
      redirect_to new_application_letter_path(:event_id => @event.id)
    end
    @free_places = @event.compute_free_places
    @occupied_places = @event.compute_occupied_places
    @application_letters = filter_application_letters(@event.application_letters)
    @material_files = get_material_files(@event)
    @material_directories = get_material_directory_list(@event)
    @has_free_places = @free_places > 0
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
    if @event.save
      redirect_to @event, notice: I18n.t('.events.notices.created')
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    attrs = event_params
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
    authorize! :print_badges, @event
    @participants = @event.participants
  end

  # POST /events/1/badges
  def print_badges
    authorize! :print_badges, @event
    @participants = @event.participants
    name_format = params[:name_format]
    show_color = params[:show_color]
    show_organisation = params[:show_organisation]
    logo = params[:logo_upload]

    selected_ids = params[:selected_ids]
    selected_participants = User.where(id: selected_ids)
    # remove users who are not actual participants
    selected_participants &= @participants
    if selected_participants.empty?
      flash.now[:error] = I18n.t('events.badges.no_users_selected')
      render 'badges' and return
    end

    begin
      pdf = BadgesPDF.generate(@event, selected_participants, name_format, show_color, show_organisation, logo)
      send_data pdf, filename: "badges.pdf", type: "application/pdf", disposition: "inline"
    rescue Prawn::Errors::UnsupportedImageType
      flash.now[:error] = I18n.t('events.badges.wrong_file_format')
      render 'badges'
    end
  end

  # GET /events/1/participants
  def participants
    @participants = @event.participants_by_agreement_letter
    @has_agreement_letters = @event.agreement_letters.any?
    @has_participants = @event.participants.any?
  end

  # GET /events/1/print_applications
  def print_applications
    authorize! :print_applications, @event
    pdf = ApplicationsPDF.generate(@event)
    send_data pdf, filename: "applications_#{@event.name}_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
  end

  def print_applications_eating_habits
    #authorize! :print_applications_eating_habits, @event
    pdf = ParticipantsPDF.generate(@event)
    send_data pdf, filename: "applications_eating_habits_#{@event.name}_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
  end

  # GET /events/1/accept-all-applicants
  def accept_all_applicants
    event = Event.find(params[:id])
    event.accept_all_application_letters
    redirect_to event_path(event)
  end

  # GET /events/1/send-participants-email
  def send_participants_email
    authorize! :send_email, Email
    event = Event.find(params[:id])
    @email = event.generate_participants_email(params[:all],params[:groups], params[:users])
    @templates = []
    @send_generic = true
    render '/emails/email'
  end

  #POST /events/1/participants/agreement_letters
  # creates either a zip or a pdf containing all agreement letters for all selected participants
  def download_agreement_letters
    @event = Event.find(params[:id])
    if not params.has_key?(:selected_participants)
      redirect_to event_participants_url(@event), notice: I18n.t('events.agreement_letters_download.notices.no_participants_selected') and return
    end
    authorize! :print_agreement_letters, @event
    if params[:download_type] == "zip"
      filename = "agreement_letters_#{@event.name}_#{Date.today}.zip"
      temp_file = Tempfile.new(filename)
      number_of_files = 0
      begin
        Zip::OutputStream.open(temp_file) { |zos| }
        Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
          params[:selected_participants].each do |participant_id|
            user = User.find(participant_id)
            agreement_letter = user.agreement_letter_for_event(@event)

            unless agreement_letter.nil?
              number_of_files += 1
              zipfile.add(number_of_files.to_s + "_" + user.name + ".pdf", agreement_letter.path)
            end
          end
        end
        zip_data = File.read(temp_file.path)
        if number_of_files != 0
          send_data(zip_data, :type => 'application/zip', :filename => filename)
        end
      ensure
        temp_file.close
        temp_file.unlink
      end
      if number_of_files == 0
        redirect_to event_participants_url(@event), notice: I18n.t('events.agreement_letters_download.notices.no_agreement_letters') and return
      end
    end
    if params[:download_type] == "pdf"
      empty = true
      pdf = CombinePDF.new
      params[:selected_participants].each do |participant_id|
        agreement_letter = User.find(participant_id).agreement_letter_for_event(@event)
        unless agreement_letter.nil?
          pdf << CombinePDF.load(agreement_letter.path)
          empty = false
        end
      end
      if empty
        redirect_to event_participants_url(@event), notice: I18n.t('events.agreement_letters_download.notices.no_agreement_letters') and return
      end
      send_data pdf.to_pdf, filename: "agreement_letters_#{@event.name}_#{Date.today}.pdf", type: "application/pdf", disposition: "inline" unless pdf.nil?
    end
  end

  # POST /events/1/upload_material
  def upload_material
    event = Event.find(params[:event_id])
    material_path = params[:path] == ''? File.join(event.material_path, params[:path]) : event.material_path
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

  # GET /event/1/participants_pdf
  def participants_pdf
    default = {:order_by => 'email', :order_direction => 'asc'}
    default = default.merge(params)

    @application_letters = @event.application_letters_ordered(default[:order_by], default[:order_direction])
                               .where(:status => ApplicationLetter.statuses[:accepted])

    data = @application_letters.collect do |application_letter|
      [
        application_letter.user.profile.first_name,
        application_letter.user.profile.last_name,
        application_letter.user.profile.birth_date,
        application_letter.allergies
      ]
    end

    data.unshift([
     I18n.t('controllers.events.participants_pdf.first_name'),
     I18n.t('controllers.events.participants_pdf.last_name'),
     I18n.t('controllers.events.participants_pdf.first_name'),
     I18n.t('controllers.events.participants_pdf.allergies')
    ])

    name = @event.name
    doc = Prawn::Document.new(:page_size => 'A4') do
      text "Teilnehmerliste - " + name
      table(data, width: bounds.width)
    end

    send_data doc.render, :filename => "participants.pdf", :type => "application/pdf", disposition: "inline"
  end

  # POST /events/1/download_material
  def download_material
    event = Event.find(params[:event_id])
    unless params.has_key?(:file)
      redirect_to event_path(event), alert: I18n.t('events.material_area.no_file_given') and return
    end
    authorize! :download_material, event

    file_full_path = File.join(event.material_path, params[:file])
    unless File.exists?(file_full_path)
      redirect_to event_path(event), alert: t('events.material_area.download_file_not_found') and return
    end
    send_file file_full_path, :x_sendfile => true
  end

  def move_material
    event = Event.find(params[:event_id])
    unless params.has_key?(:from) and params.has_key?(:to)
      redirect_to event_path(event), alert: I18n.t('events.material_area.no_file_given') and return
    end

    move_file(event, params[:from], params[:to])
    redirect_to event_path(event), notice: I18n.t('events.material_area.file_moved')
  end

  def remove_material
    event = Event.find(params[:event_id])
    unless params.has_key?(:path)
      redirect_to event_path(event), alert: I18n.t('events.material_area.no_file_given') and return
    end

    remove_file(event, params[:path])
    redirect_to event_path(event), notice: I18n.t('events.material_area.file_removed')
  end

  def make_material_folder
    event = Event.find(params[:event_id])
    unless params.has_key?(:path) and params.has_key?(:name)
      redirect_to event_path(event), alert: I18n.t('events.material_area.no_file_given') and return
    end

    make_dir(event, params[:path], params[:name])
    redirect_to event_path(event), notice: I18n.t('events.material_area.dir_created')
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :description, :image, :max_participants, :organizer, :knowledge_level, :application_deadline, :published, :hidden, :custom_application_fields => [], date_ranges_attributes: [:start_date, :end_date, :id])
    end

    def add_event_query_conditions(query)
      conditions = {}
      conditions[:hidden] = false unless can? :view_hidden, Event
      conditions[:published] = true unless can? :view_unpublished, Event
      query.where(conditions)
    end

    def filter_application_letters(application_letters)
      application_letters = application_letters.to_a
      filters = (params[:filter] || {}).select { |k, v| v == '1' }.map{ |k, v| k.to_s }
      if filters.count > 0  # skip filtering if no filters have been set
        application_letters.keep_if { |l| filters.include?(l.status) }
      end
      application_letters
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
      if File.exists?(material_path)
        build_files(material_path, '')
      else
        []
      end
    end

    def get_material_directory_list(event)
      material_path = event.material_path
      if File.exists?(material_path)
        [['/','']].concat(build_directories(material_path, ''))
      else
        [['/','']]
      end
    end

    def build_directories(base_path, current_path)
      list = []
      path = current_path == '' ? base_path : File.join(base_path, current_path)
      Dir.foreach(path) do |file|
        unless file == '.' or file == '..'
          sub_path = current_path == '' ? file : File.join(current_path, file)
          if File.directory?(File.join(path, file))
            list.push(['/' + sub_path, sub_path])
            list = list.concat(build_directories(base_path, sub_path))
          end
        end
      end
      list
    end

    def build_files(base_path, current_path)
      list = []
      path = current_path == '' ? base_path : File.join(base_path, current_path)
      Dir.foreach(path) do |file|
        unless file == '.' or file == '..'
          sub_path = current_path == '' ? file : File.join(current_path, file)
          hash = {:name => file, :path  => sub_path}
          if File.directory?(File.join(path, file))
            hash[:type] = 'dir'
            hash[:content] = build_files(base_path, sub_path)
            hash[:empty] = hash[:content].length == 0 ? true : false
          else
            hash[:type] = 'file'
          end
          list.push hash
        end
      end
      list.sort { |a,b|
        if a[:type] == b[:type]
          a[:name] <=> b[:name]
        else
          a[:type] == 'dir' ? -1 : 1
        end
      }
    end

    # Moves one material file to another place
    #
    # @param [Event] The event to update
    # @param [String] from The path of the file at the moment
    # @param [String] to The path of the directory to move into (can be /)
    # @return [None]
    def move_file(event, fr, to)
      fr = File.join(event.material_path,fr)
      to = File.join(event.material_path,to)
      if File.exists?(fr) and File.exists?(to) and File.directory?(to)
        FileUtils.mv(fr,File.join(to, File.basename(fr)))
      end
    end

    # Removes one material file
    #
    # @param [Event] The event to change
    # @param [String] The path of the file in the event dir to remove
    # @return [None]
    def remove_file(event, path)
      path = File.join(event.material_path,path)
      FileUtils.rm_rf(path) if File.exists?(path)
    end

    # Adds an directory
    #
    # @param [Event]
    # @param [String]
    # @return [None]
    def   make_dir(event, path, name)
      path = File.join(event.material_path, path)
      full_path = File.join(path, name)
      Dir.mkdir(full_path) if Dir.exists?(path)
    end
end
