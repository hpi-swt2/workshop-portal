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

  it "returns users accepted application count" do
    user = FactoryGirl.build(:user)
    expect(user.accepted_application_count).to eq(0)
  end

  it "returns users rejected application count" do
    user = FactoryGirl.build(:user)
    expect(user.rejected_application_count).to eq(0)
  end

  it "returns correct accepted and rejected application count" do
    user = FactoryGirl.create(:user)
    # Add two accepted and one rejected application
    user.application_letters.push(FactoryGirl.create(:application_letter, status: true))
    user.application_letters.push(FactoryGirl.create(:application_letter, status: false))
    user.application_letters.push(FactoryGirl.create(:application_letter, status: true))

    expect(user.accepted_application_count).to eq(2)
    expect(user.rejected_application_count).to eq(1)
  end

  it "return correct participation count" do
    user = FactoryGirl.create(:user)
    # Add two participations
    user.application_letters.push(FactoryGirl.create(:application_letter, status: true))
    user.application_letters.push(FactoryGirl.create(:application_letter, status: true))

    expect(user.participation_count).to eq(2)
  end
end
