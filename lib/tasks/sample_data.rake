require './db/sample_data'

namespace :db do
  desc 'Populates the database with sample data'
  task populate_sample_data: :environment do
    add_sample_data
  end
end