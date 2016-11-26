# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  active           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

describe Event do

  it "is created by event factory" do
    event = FactoryGirl.build(:event)
    expect(event).to be_valid
  end
end
