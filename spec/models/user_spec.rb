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

  it "returns correct default accepted applications count" do
    application_letter = FactoryGirl.create(:application_letter)
    expect(application_letter.user.accepted_applications_count(application_letter.event)).to eq(0)
  end

  it "returns correct default rejected applications count" do
    application_letter = FactoryGirl.create(:application_letter)
    expect(application_letter.user.rejected_applications_count(application_letter.event)).to eq(0)
  end

  it "only counts the accepted application of other events and ignores status of current event application" do
    user = FactoryGirl.create(:user)
    other_event = FactoryGirl.create(:event)
    current_event = FactoryGirl.create(:event)

    other_application_letter = FactoryGirl.create(:application_letter, user: user, event: other_event, status: true)
    current_application_letter = FactoryGirl.create(:application_letter, user: user, event: current_event, status: true)

    expect(current_application_letter.user.accepted_applications_count(current_event)).to eq(1)
  end

  it "only counts the rejected application of other events and ignores status of current event application" do
    user = FactoryGirl.create(:user)
    other_event = FactoryGirl.create(:event)
    current_event = FactoryGirl.create(:event)

    other_application_letter = FactoryGirl.create(:application_letter, user: user, event: other_event, status: false)
    current_application_letter = FactoryGirl.create(:application_letter, user: user, event: current_event, status: false)

    expect(current_application_letter.user.rejected_applications_count(current_event)).to eq(1)
  end

end
