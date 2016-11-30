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

  it "checks if there are unclassified applications_letters" do
    event = FactoryGirl.create(:event)
    acceptedApplicationLetter = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user), :status => 1)
    event.application_letters.push(acceptedApplicationLetter)
    expect(event.applicationsClassified?).to eq(true)

    rejectedApplicationLetter = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user), :status => 2)
    event.application_letters.push(rejectedApplicationLetter)
    expect(event.applicationsClassified?).to eq(false)
  end

  it "computes the email addreses of the accepted and the rejected applications" do
    event = FactoryGirl.create(:event)
    acceptedApplicationLetter1 = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user), :status => 1)
    acceptedApplicationLetter2 = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user), :status => 1)
    acceptedApplicationLetter3 = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user), :status => 1)
    rejectedApplicationLetter = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user), :status => 0)
    event.application_letters.push(acceptedApplicationLetter1)
    event.application_letters.push(acceptedApplicationLetter2)
    event.application_letters.push(acceptedApplicationLetter3)
    event.application_letters.push(rejectedApplicationLetter)
    expect(event.compute_accepted_applications_emails).to eq([acceptedApplicationLetter1.user.email, acceptedApplicationLetter2.user.email, acceptedApplicationLetter3.user.email].join(','))
    expect(event.compute_rejected_applications_emails).to eq([rejectedApplicationLetter.user.email].join(','))
  end

  it "computes the number of free places" do
    event = FactoryGirl.create(:event)
    application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), event: event)
    event.application_letters.push(application_letter)

    expect(event.compute_free_places).to eq(event.max_participants - event.compute_occupied_places)
  end

  it "computes the number of occupied places" do
    event = FactoryGirl.create(:event)
    application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), event: event)
    application_letter_accepted = FactoryGirl.create(:application_letter_accepted, user: FactoryGirl.create(:user), event: event)
    event.application_letters.push(application_letter)
    event.application_letters.push(application_letter_accepted)
    expect(event.compute_occupied_places).to eq(1)
    application_letter_accepted_2 = FactoryGirl.create(:application_letter_accepted, user: FactoryGirl.create(:user), event: event)
    event.application_letters.push(application_letter_accepted_2)
    expect(event.compute_occupied_places).to eq(2)
  end
end
