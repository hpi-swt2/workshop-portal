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
    true_letter = FactoryGirl.create(:accepted_application_letter)
    false_letter = FactoryGirl.create(:rejected_application_letter)
    application_letters = [true_letter, false_letter]
    user = FactoryGirl.build(:user, application_letters: application_letters)
    expect(user.events).to eq [true_letter.event]
  end
  
  it "returns the correct letter of agreement for a given event" do
    event = FactoryGirl.create(:event)
	user = FactoryGirl.create(:user)
	application_letter = FactoryGirl.create(:accepted_application_letter, event: event, user: user)
	agreement_letter = FactoryGirl.create(:agreement_letter, event: event, user: user)
	expect(user.agreement_letter_for_event(event)).to eq event
  end
end
