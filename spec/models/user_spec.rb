# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string
#  sign_in_count          :integer          default(0), not null
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
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

  it "has a username described by either email or profile name if it exists" do
    user = FactoryGirl.build(:user, email: 'email@example.com')
    expect(user.name).to eq 'email@example.com'

    user = FactoryGirl.build(:user_with_profile)
    expect(user.name).to eq user.profile.name
  end

  it "returns the users events" do
	user = FactoryGirl.build(:user)
    true_letter = FactoryGirl.create(:application_letter, :accepted, user: user)
    false_letter = FactoryGirl.create(:application_letter, :rejected, user: user)
    expect(user.events).to eq ([true_letter.event])
  end
  
  it "returns the correct letter of agreement for a given event" do
    event = FactoryGirl.create(:event)
    user = FactoryGirl.create(:user)
    application_letter = FactoryGirl.create(:application_letter, :accepted, event: event, user: user)
    agreement_letter = FactoryGirl.create(:agreement_letter, event: event, user: user)
    expect(user.agreement_letter_for_event?(event)).to eq true
    expect(user.agreement_letter_for_event(event)).to eq agreement_letter
    other_event = FactoryGirl.create(:event)
    expect(user.agreement_letter_for_event?(other_event)).to eq false
  end

  it "returns the correct application for a given event" do
    event = FactoryGirl.create(:event)
    user = FactoryGirl.create(:user, role: :pupil)
    application_letter = FactoryGirl.create(:application_letter, event: event, user: user)
    expect(user.application_letter_for_event?(event)).to eq true
    expect(user.application_letter_for_event(event)).to eq application_letter
    other_event = FactoryGirl.create(:event)
    expect(user.application_letter_for_event?(other_event)).to eq false

  end

  it "returns correct default accepted applications count" do
    application_letter = FactoryGirl.create(:application_letter)
    expect(application_letter.user.accepted_applications_count(application_letter.event)).to eq(0)
  end

  it "computes the correct number of accepted applications" do
    user = FactoryGirl.create(:user)
    application_letter = FactoryGirl.create(:application_letter, event: FactoryGirl.create(:event), user: user)
    application_letter_accepted = FactoryGirl.create(:application_letter, :accepted, event: FactoryGirl.create(:event), user: user)
    expect(user.accepted_applications_count(FactoryGirl.create(:event))).to eq(1)
    application_letter_accepted_2 = FactoryGirl.create(:application_letter, :accepted, event: FactoryGirl.create(:event), user: user)
    expect(user.accepted_applications_count(FactoryGirl.create(:event))).to eq(2)
  end

  it "returns correct default rejected applications count" do
    application_letter = FactoryGirl.create(:application_letter)
    expect(application_letter.user.rejected_applications_count(application_letter.event)).to eq(0)
  end

  it "computes the correct number of rejected applications" do
    user = FactoryGirl.create(:user)
    application_letter = FactoryGirl.create(:application_letter, event: FactoryGirl.create(:event), user: user)
    application_letter_rejected = FactoryGirl.create(:application_letter, :rejected, event: FactoryGirl.create(:event), user: user)
    expect(user.rejected_applications_count(FactoryGirl.create(:event))).to eq(1)
    application_letter_rejected_2 = FactoryGirl.create(:application_letter, :rejected, event: FactoryGirl.create(:event), user: user)
    expect(user.rejected_applications_count(FactoryGirl.create(:event))).to eq(2)
  end

  it "only counts the accepted application of other events and ignores status of current event application" do
    user = FactoryGirl.create(:user)
    other_event = FactoryGirl.create(:event)
    current_event = FactoryGirl.create(:event)

    other_application_letter = FactoryGirl.create(:application_letter, :accepted, user: user, event: other_event)
    current_application_letter = FactoryGirl.create(:application_letter, :accepted, user: user, event: current_event)

    expect(current_application_letter.user.accepted_applications_count(current_event)).to eq(1)
  end

  it "only counts the rejected application of other events and ignores status of current event application" do
    user = FactoryGirl.create(:user)
    other_event = FactoryGirl.create(:event)
    current_event = FactoryGirl.create(:event)

    other_application_letter = FactoryGirl.create(:application_letter, :rejected, user: user, event: other_event)
    current_application_letter = FactoryGirl.create(:application_letter, :rejected, user: user, event: current_event)

    expect(current_application_letter.user.rejected_applications_count(current_event)).to eq(1)
  end

  it "raises an error when given an invalid role" do
    user = FactoryGirl.build(:user)
    expect{user.role? :forty_two }.to raise_error
  end

  it "filters for users with Max in their name" do
    max = FactoryGirl.create(:user)
    max.profile = FactoryGirl.create(:profile, first_name: "Max")
    user3 = FactoryGirl.create(:user_with_profile)

    expect(User.search("Max")).to include(max)
    expect(User.search("Max")).to_not include(user3)
  end

end
