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

  it "computes the number of free places" do
    workshop = FactoryGirl.create(:event)
    application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), event: workshop)
    workshop.application_letters.push(application_letter)

    expect(workshop.compute_free_places).to eq(workshop.max_participants - workshop.compute_occupied_places)
  end

  it "computes the number of occupied places" do
    workshop = FactoryGirl.create(:event)
    application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), event: workshop)
    workshop.application_letters.push(application_letter)

    expect(workshop.compute_occupied_places).to eq(workshop.application_letters.where(status: 1).count)
  end
end
