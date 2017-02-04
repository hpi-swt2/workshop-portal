class EventImageUploader < CarrierWave::Uploader::Base
  attr_reader :upload_width, :upload_height

  # image processing
  include CarrierWave::MiniMagick

  storage :file

  # Return the directory that images will be uploaded to
  # @return [String] the path relative to the `public` folder
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  before :cache, :capture_size_before_cache

  # Fill in the upload sizes once the image has been uploaded, so that
  # our model can use them for validation
  def capture_size_before_cache(new_file) 
    # Only do this once, to the original version
    if version_name.blank?
        @upload_width, @upload_height = `identify -format "%wx %h" #{new_file.path}`.split(/x/).map { |dim| dim.to_i }
    end
  end

  version :list_view do
    process resize_to_fill: [200, 155]
  end

  version :detail_view do
    process resize_to_fill: [1140, 200]
  end

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  # white list of extensions which are allowed to be uploaded
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

end
