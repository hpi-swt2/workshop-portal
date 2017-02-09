require 'rubygems'
require 'zip'

class MaterialsController < ApplicationController

  before_action :set_and_authorize_event

  # POST /events/1/upload_material
  def upload_material
    Dir.mkdir(@event.material_path) unless Dir.exists?(@event.material_path)

    path = params[:path].to_s
    file = params[:file_upload]

    if !is_file?(file)
      redirect_to event_path(@event), alert: t("events.material_area.no_file_given") and return
    elsif invalid_pathname?(path) || invalid_filename?(file.original_filename)
      redirect_to event_path(@event), alert: t("events.material_area.invalid_path_given") and return
    elsif !File.directory?(File.join(@event.material_path, path))
      redirect_to event_path(@event), alert: t("events.material_area.download_file_not_found") and return
    end

    file_path = File.join(@event.material_path, path, file.original_filename)
    begin
      File.write(file_path, file.read, mode: "wb")
    rescue IOError
      redirect_to event_path(@event), alert: t("events.material_area.saving_fails") and return
    end

    redirect_to event_path(@event), notice: I18n.t("events.material_area.success_message")
  end

  # POST /events/1/download_material
  def download_material
    file_full_path = File.join(@event.material_path, params[:file].to_s)

    if !params.has_key?(:file)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    elsif invalid_pathname? params[:file]
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    elsif !File.exists?(file_full_path)
      redirect_to event_path(@event), alert: t('events.material_area.download_file_not_found') and return
    end

    if File.directory?(file_full_path)
      send_zipped_materials(file_full_path)
    else
      send_file file_full_path, x_sendfile: true
    end
  end

  def move_material
    from_path = File.join(@event.material_path, params[:from].to_s)
    to_path = File.join(@event.material_path, params[:to].to_s)

    if !params.has_key?(:from) or !params.has_key?(:to)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    elsif invalid_pathname?(params[:from]) || invalid_pathname?(params[:to])
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    elsif params[:to] == params[:from] or params[:to].start_with?(params[:from] + File::SEPARATOR)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.cant_move_in_child') and return
    elsif !File.exists?(from_path) or !File.exists?(to_path) or !File.directory?(to_path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.download_file_not_found') and return
    elsif File.exists?(File.join(to_path, File.basename(from_path)))
      redirect_to event_path(@event), alert: I18n.t('events.material_area.already_exists') and return
    end

    move_file(from_path, to_path)
    redirect_to event_path(@event), notice: I18n.t('events.material_area.file_moved')
  end

  def rename_material
    from_path = File.join(@event.material_path, params[:from].to_s)
    to_path = File.join(File.dirname(from_path), params[:to].to_s)

    if !params.has_key?(:from) or !params.has_key?(:to)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    elsif invalid_pathname?(params[:from]) || invalid_filename?(params[:to])
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    elsif !File.exists?(from_path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.download_file_not_found') and return
    elsif File.exists?(to_path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.already_exists') and return
    end

    rename_file(from_path, to_path)
    redirect_to event_path(@event), notice: I18n.t('events.material_area.file_renamed')
  end

  def remove_material
    path = File.join(@event.material_path, params[:path].to_s)
    if !params.has_key?(:path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    elsif invalid_pathname?(params[:path])
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    elsif !File.exists?(path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.download_file_not_found') and return
    end

    remove_file(path)
    redirect_to event_path(@event), notice: I18n.t('events.material_area.file_removed')
  end

  def make_material_folder
    Dir.mkdir(@event.material_path) unless File.directory?(@event.material_path)
    path = File.join(@event.material_path, params[:path].to_s)
    new_dir_path = File.join(path, params[:name].to_s)

    if !params.has_key?(:path) or !params.has_key?(:name)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.no_file_given') and return
    elsif invalid_pathname?(params[:path]) || invalid_filename?(params[:name])
      redirect_to event_path(@event), alert: I18n.t('events.material_area.invalid_path_given') and return
    elsif !Dir.exists?(path)
      redirect_to event_path(@event), alert: I18n.t('events.material_area.download_file_not_found') and return
    elsif File.exists? new_dir_path
      redirect_to event_path(@event), alert: I18n.t('events.material_area.already_exists') and return
    end

    make_dir(new_dir_path)
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
      FileUtils.mv(fr, File.join(to, File.basename(fr)))
    end

    # Moves one material file to another place
    #
    # @param [String] fr The path of the file at the moment
    # @param [String] to The path of the directory to move into (can be /)
    # @return [None]
    def rename_file(fr, to)
      File.rename(fr, to)
    end

    # Removes one material file or directory
    #
    # @param [String] path The path of the file in the event dir to remove
    # @return [None]
    def remove_file(path)
      FileUtils.rm_rf(path)
    end

    # Adds a directory
    #
    # @param [String] full_path The path where the directory should be added
    # @return [None]
    def make_dir(full_path)
      Dir.mkdir(full_path)
    end

    # Collects all files in the given directory and generates an zip-file.
    #
    # @param full_path [String] The full absolute path to look up
    # @return [None]
    def send_zipped_materials(full_path)
      filename = "material_#{@event.name}_#{Date.today}.zip"
      temp_file = Tempfile.new(filename)
      begin
        Zip::OutputStream.open(temp_file) { |zos| }
        Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
          collect_files_for_zip(full_path, '.', zipfile)
        end
        zip_data = File.read(temp_file.path)
        send_data(zip_data, type: 'application/zip', filename: filename, disposition: 'inline', x_sendfile: true)
      ensure
        temp_file.close
        temp_file.unlink
      end
    end

    def collect_files_for_zip(material_path, current_path, zip)
      absolute_path = File.join(material_path, current_path)
      Dir.foreach(absolute_path) do |file|
        next if file == '.' || file == '..'

        absolute_file_path = File.join(absolute_path, file)
        relative_file_path = File.join(current_path, file)
        if File.directory?(absolute_file_path)
          zip.mkdir(absolute_file_path)
          collect_files_for_zip(material_path, relative_file_path, zip)
        else
          zip.add(relative_file_path, absolute_file_path)
        end
      end
    end

    def invalid_pathname?(pathname)
      (Pathname(pathname).absolute?) || (contains_invalid_chars(pathname))
    end

    def invalid_filename?(pathname)
      (/[\/\\]/ =~ pathname) ||
        (pathname == '.') ||
        (pathname == '') ||
        (contains_invalid_chars(pathname))
    end

    def contains_invalid_chars(pathname)
      (/^\S*\.\.+\S*$/ =~ pathname) || (/[:*?|"<>]/ =~ pathname)
    end
end
