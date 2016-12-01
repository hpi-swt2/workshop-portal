# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#

require 'rails_helper'

describe User do

  it "is created by user factory" do
    user = FactoryGirl.create(:user)
    expect(user).to be_valid
  end

  it "cannot create a user without an email address" do
    user = FactoryGirl.build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it "returns the user's events" do
    user = FactoryGirl.build(:user)
    FactoryGirl.create(:application_letter_rejected, user: user)
    accepted_letter = FactoryGirl.create(:application_letter_accepted, user: user)
    expect(user.events).to eq [accepted_letter.event]
  end

  it "returns correct default accepted applications count" do
    application_letter = FactoryGirl.create(:application_letter)
    expect(application_letter.user.accepted_applications_count(application_letter.event)).to eq(0)
  end

  it "computes the correct number of accepted applications" do
    user = FactoryGirl.create(:user)
    application_letter = FactoryGirl.create(:application_letter, event: FactoryGirl.create(:event), user: user)
    application_letter_accepted = FactoryGirl.create(:application_letter_accepted, event: FactoryGirl.create(:event), user: user)
    expect(user.accepted_applications_count(FactoryGirl.create(:event))).to eq(1)
    application_letter_accepted_2 = FactoryGirl.create(:application_letter_accepted, event: FactoryGirl.create(:event), user: user)
    expect(user.accepted_applications_count(FactoryGirl.create(:event))).to eq(2)
  end

  it "returns correct default rejected applications count" do
    application_letter = FactoryGirl.create(:application_letter)
    expect(application_letter.user.rejected_applications_count(application_letter.event)).to eq(0)
  end

  it "computes the correct number of rejected applications" do
    user = FactoryGirl.create(:user)
    application_letter = FactoryGirl.create(:application_letter, event: FactoryGirl.create(:event), user: user)
    application_letter_rejected = FactoryGirl.create(:application_letter_rejected, event: FactoryGirl.create(:event), user: user)
    expect(user.rejected_applications_count(FactoryGirl.create(:event))).to eq(1)
    application_letter_rejected_2 = FactoryGirl.create(:application_letter_rejected, event: FactoryGirl.create(:event), user: user)
    expect(user.rejected_applications_count(FactoryGirl.create(:event))).to eq(2)
  end

  it "only counts the accepted application of other events and ignores status of current event application" do
    user = FactoryGirl.create(:user)
    other_event = FactoryGirl.create(:event)
    current_event = FactoryGirl.create(:event)

    other_application_letter = FactoryGirl.create(:application_letter_accepted, user: user, event: other_event)
    current_application_letter = FactoryGirl.create(:application_letter_accepted, user: user, event: current_event)

    expect(current_application_letter.user.accepted_applications_count(current_event)).to eq(1)
  end

  it "only counts the rejected application of other events and ignores status of current event application" do
    user = FactoryGirl.create(:user)
    other_event = FactoryGirl.create(:event)
    current_event = FactoryGirl.create(:event)

    other_application_letter = FactoryGirl.create(:application_letter_rejected, user: user, event: other_event)
    current_application_letter = FactoryGirl.create(:application_letter_rejected, user: user, event: current_event)

    expect(current_application_letter.user.rejected_applications_count(current_event)).to eq(1)
  end

end
