Airbrake.configure do |config|
  config.host = 'https://swt2-errbit-2016.herokuapp.com'
  config.project_id = 1
  config.project_key = '7cdd58bf325c8a3c1ddb90b34566c94b'
  config.environment = Rails.env
  config.ignore_environments = %w(development test cucumber)
end

Airbrake.add_filter do |notice|
  # The library supports nested exceptions, so one notice can carry several
  # exceptions.

  if notice[:context][:url].include? "://localhost:"
    notice.ignore!
  end
end