require 'rails_helper'

describe 'Seeds' do
  it 'should seed the database without errors' do
    Rails.application.load_seed
  end
end