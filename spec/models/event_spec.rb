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

  it "returns the event's participants" do
    event = FactoryGirl.build(:event)
    FactoryGirl.create(:rejected_application_letter, event: event)
    true_letter = FactoryGirl.create(:accepted_application_letter, event: event)
    expect(event.participants).to eq [true_letter.user]
  end

  it "returns a user's agreement letter for itself" do
    event = FactoryGirl.create(:event)
    user = FactoryGirl.create(:user)
    irrelevant_user = FactoryGirl.create(:user)
    FactoryGirl.create(:agreement_letter, user: irrelevant_user)
    agreement_letter = FactoryGirl.create(:agreement_letter, user: user, event: event)
    expect(event.agreement_letter_for(user)).to eq agreement_letter
  end

  it "returns nil if a user has not uploaded an agreement letter" do
    event = FactoryGirl.create(:event)
    user = FactoryGirl.create(:user)
    irrelevant_user = FactoryGirl.create(:user)
    FactoryGirl.create(:agreement_letter, user: irrelevant_user)
    expect(event.agreement_letter_for(user)).to be_nil
  end
end
