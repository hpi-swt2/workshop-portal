require 'rails_helper'

describe 'Seeds' do
  it 'should seed the database without errors' do
    expect{
      # Try to seed the databse. Same as executing db:seed.
      Rails.application.load_seed
    }.to_not raise_error
  end
end