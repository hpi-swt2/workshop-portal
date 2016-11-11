Airbrake.configure do |config|
  config.host = 'https://swt2-errbit-2016.herokuapp.com'
  config.project_id = 1
  config.project_key = '7cdd58bf325c8a3c1ddb90b34566c94b'
  config.ignore_environments = %w(development test cucumber)
end