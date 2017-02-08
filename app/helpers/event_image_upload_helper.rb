module EventImageUploadHelper
  # @return [Array] paths to all stock photos
  def stock_photo_paths
    Dir.glob('app/assets/images/stock_photos/*').map do |image|
      'stock_photos/' + image.split('/').last
    end
  end

  # Given a path returns the string stripped from all invalid chars in an id
  #
  # @param path [String] the path to be stripped
  # @return [String] the id
  def path_to_id(path)
    path.gsub(/[^A-Za-z0-9._-]/, '')
  end
end
