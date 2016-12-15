require 'rails_helper'
require 'rake'

describe 'Seeds' do
  it 'should seed the database without errors' do
    expect{
      # Try to seed the databse. Same as executing db:seed.
      Rails.application.load_seed
    }.to_not raise_error
  end
end

describe 'Sample data' do
  it 'should load sample data without errors' do
    Rails.application.load_tasks
    Rake::Task['db:populate_sample_data'].invoke
  end
end