require 'rubygems'
require 'zip'

class MaterialsController < ApplicationController

  before_action :set_and_authorize_event

  # POST /events/1/upload_material
  def upload_material
    unless File.directory?(@event.material_path)
      Dir.mkdir(@event.material_path)
    end

    path = params[:path].to_s
    file = params[:file_upload]

    unless is_file?(file)
      redirect_to event_path(@event), alert: t("events.material_area.no_file_given")
      return false
    end

    if invalid_pathname?(path) or invalid_filename?(file.original_filename)
      redirect_to event_path(@event), alert: t("events.material_area.invalid_path_given") and return
    end
    material_path = if path == ''
      @event.material_path
    else
      File.join(@event.material_path, path)
    end

    unless File.directory?(material_path)
      redirect_to event_path(@event), alert: t("events.material_area.download_file_not_found") and return
    end

    begin
      File.write(File.join(material_path, file.original_filename), file.read, mode: "wb")
    rescue IOError
      redirect_to event_path(@event), alert: I18n.t("events.material_area.saving_fails")
      return false
    end
    redirect_to event_path(@event), notice: I18n.t("events.material_area.success_message")
  end

  # POST /events/1/download_material
  def download_material

    unless params.has_key?(:file)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    end
    if invalid_pathname? params[:file]
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    end

    file_full_path = File.join(@event.material_path, params[:file])
    unless File.exists?(file_full_path)
      redirect_to event_path(@event), alert: t('events.material_area.download_file_not_found') and return
    end
    if File.directory?(file_full_path)
      send_zipped_materials(file_full_path) and return
    end
    send_file file_full_path, :x_sendfile => true
  end

  def move_material
    unless params.has_key?(:from) and params.has_key?(:to)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    end
    if invalid_pathname?(params[:from]) || invalid_pathname?(params[:to])
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    end

    if params[:to] == params[:from] or params[:to].start_with?(params[:from] + File::SEPARATOR)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.cant_move_in_child') and return
    end

    fr = File.join(@event.material_path,params[:from])
    to = File.join(@event.material_path,params[:to])
    unless File.exists?(fr) and File.exists?(to) and File.directory?(to)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.download_file_not_found') and return
    end
    if File.exists?(File.join(to, File.basename(fr)))
      redirect_to event_path(@event), alert: I18n.t('events.material_area.already_exists') and return
    end

    move_file(fr, to)
    redirect_to event_path(@event), notice: I18n.t('events.material_area.file_moved')
  end

  def rename_material

    unless params.has_key?(:from) and params.has_key?(:to)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    end
    if invalid_pathname?(params[:from]) || invalid_filename?(params[:to])
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    end

    fr = File.join(@event.material_path,params[:from])
    to = File.join(File.dirname(fr),params[:to])
    unless File.exists?(fr)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.download_file_not_found') and return
    end
    if File.exists?(to)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.already_exists') and return
    end
    rename_file(fr, to)
    redirect_to event_path(@event), notice: I18n.t('events.material_area.file_renamed')
  end

  def remove_material
    unless params.has_key?(:path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    end
    if invalid_pathname?(params[:path])
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    end

    path = File.join(event.material_path,params[:path])
    unless File.exists?(path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.download_file_not_found') and return
    end
    remove_file(path)
    redirect_to event_path(@event), notice: I18n.t('events.material_area.file_removed')
  end

  def make_material_folder
    unless File.directory?(@event.material_path)
      Dir.mkdir(@event.material_path)
    end

    unless params.has_key?(:path) and params.has_key?(:name)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    end
    if invalid_pathname?(params[:path]) || invalid_filename?(params[:name])
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    end

    path = File.join(@event.material_path, params[:path])
    full_path = File.join(path, params[:name])
    unless Dir.exists?(path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.download_file_not_found') and return
    end
    if File.exists? full_path
      redirect_to event_path(@event), alert: I18n.t('events.material_area.already_exists') and return
    end
    make_dir(full_path)
    redirect_to event_path(@event), notice: I18n.t('events.material_area.dir_created')
  end

  private
    def set_and_authorize_event
      @event = Event.find(params[:event_id])
      authorize! :upload_material, @event
    end

    # Checks if a file is valid and not empty
    #
    # @param [ActionDispatch::Http::UploadedFile] file is a file object
    # @return [Boolean] whether @file is a valid file
    def is_file?(file)
      file.respond_to?(:open) && file.respond_to?(:content_type) && file.respond_to?(:size)
    end

    # Moves one material file to another place
    #
    # @param [String] fr The path of the file at the moment
    # @param [String] to The path of the directory to move into (can be /)
    # @return [None]
    def move_file(fr, to)
      FileUtils.mv(fr,File.join(to, File.basename(fr)))
    end

    # Moves one material file to another place
    #
    # @param [String] fr from The path of the file at the moment
    # @param [String] to The path of the directory to move into (can be /)
    # @return [None]
    def rename_file(fr, to)
      File.rename(fr,to)
    end

    # Removes one material file
    #
    # @param [String] path The path of the file in the event dir to remove
    # @return [None]
    def remove_file(path)
      FileUtils.rm_rf(path)
    end

    # Adds an directory
    #
    # @param [String] full_path The path where the directory should be added
    # @return [None]
    def make_dir(full_path)
        Dir.mkdir(full_path)
    end

    # Collects all files in the given directory and generates an zip-file.
    #
    # @param [String] full_path The full absolute path to look up
    # @return [None]
    def send_zipped_materials(full_path)
      filename = "material_#{@event.name}_#{Date.today}.zip"
      temp_file = Tempfile.new(filename)
      begin
        Zip::OutputStream.open(temp_file) { |zos| }
        Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
          collect_files_for_zip(full_path, '', zipfile)
        end
        zip_data = File.read(temp_file.path)
        send_data(zip_data, :type => 'application/zip', :filename => filename, :disposition => 'inline', :x_sendfile => true)
      ensure
        temp_file.close
        temp_file.unlink
      end
    end

    def collect_files_for_zip(base_path, current_path, zip)
      path = current_path == '' ? base_path : File.join(base_path, current_path)
      if current_path != ''
        zip.mkdir current_path
      end
      Dir.foreach(path) do |file|
        unless file == '.' or file == '..'
          sub_path = current_path == '' ? file : File.join(current_path, file)
          if File.directory?(File.join(path, file))
            collect_files_for_zip(base_path, sub_path, zip)
          else
            zip.add(sub_path, File.join(path, file))
          end
        end
      end
    end

    def invalid_pathname?(pathname)
      (Pathname(pathname).absolute?) || (contains_invalid_chars(pathname))
    end

    def invalid_filename?(pathname)
      (['/','\\'].any? { |s| pathname.include?(s) }) || (pathname == '.') || (pathname == '') || (contains_invalid_chars(pathname))
    end

    def contains_invalid_chars(pathname)
      ([':','*','?','|','"','<','>'].any? { |s| pathname.include?(s) }) || (/^\S*\.\.+\S*$/.match(pathname) != nil)
    end
end
