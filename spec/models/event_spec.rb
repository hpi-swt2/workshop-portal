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

  it "is either a camp or a workshop" do
    expect { FactoryGirl.build(:event, kind: :smth_invalid) }.to raise_error(ArgumentError)

    event = FactoryGirl.build(:event, kind: :camp)
    expect(event).to be_valid

    event = FactoryGirl.build(:event, kind: :workshop)
    expect(event).to be_valid
  end

end
