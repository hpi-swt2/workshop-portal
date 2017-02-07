module EventImageUploadHelper
  def stock_photo_paths
    Dir.glob('app/assets/images/stock_photos/*').map do |image|
      'stock_photos/' + image.split('/').last
    end
  end

  def path_to_id path
    path.gsub(/[^A-Za-z0-9._-]/, '')
  end
end
