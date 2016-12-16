require 'rails_helper'
# Allow using cancan helpers in tests
# https://github.com/ryanb/cancan/wiki/Testing-Abilities
require "cancan/matchers"

describe User do
  %i[pupil coach].each do |role|
    it "can create its profile" do
      user = FactoryGirl.create(:user, role: role)
      ability = Ability.new(user)

      expect(ability).to be_able_to(:new, Profile)
      expect(ability).to be_able_to(:create, Profile)
    end

    it "can access its profile" do
      user = FactoryGirl.create(:user, role: role)
      profile = FactoryGirl.create(:profile, user: user)
      ability = Ability.new(user)

      expect(ability).to be_able_to(:edit, profile)
      expect(ability).to be_able_to(:edit, profile)
      expect(ability).to be_able_to(:show, profile)
      expect(ability).to be_able_to(:index, profile)
      expect(ability).to be_able_to(:update, profile)
      expect(ability).to be_able_to(:destroy, profile)
    end

    it "cannot access another user's profile" do
      user = FactoryGirl.create(:user, role: role)
      another_user = FactoryGirl.create(:user)
      another_profile = FactoryGirl.create(:profile, user: another_user)
      ability = Ability.new(user)

      expect(ability).to_not be_able_to(:edit, another_profile)
      expect(ability).to_not be_able_to(:show, another_profile)
      expect(ability).to_not be_able_to(:update, another_profile)
      expect(ability).to_not be_able_to(:destroy, another_profile)
    end

    it "can create its application" do
      user = FactoryGirl.create(:user, role: role)
      FactoryGirl.create(:profile, user: user)
      ability = Ability.new(user)

      expect(ability).to be_able_to(:new, ApplicationLetter)
      expect(ability).to be_able_to(:create, ApplicationLetter)
    end

    it "can access its application" do
      user = FactoryGirl.create(:user, role: role)
      application = FactoryGirl.create(:application_letter, user: user)
      ability = Ability.new(user)

      expect(ability).to be_able_to(:edit, application)
      expect(ability).to be_able_to(:show, application)
      expect(ability).to be_able_to(:index, application)
      expect(ability).to be_able_to(:update, application)
      expect(ability).to be_able_to(:destroy, application)
    end

    it "cannot access another user's application" do
      user = FactoryGirl.create(:user, role: role)
      another_user = FactoryGirl.create(:user)
      another_application = FactoryGirl.create(:application_letter, user: another_user)
      ability = Ability.new(user)

      expect(ability).to_not be_able_to(:edit, another_application)
      expect(ability).to_not be_able_to(:update, another_application)
      expect(ability).to_not be_able_to(:destroy, another_application)
    end
  end

  it "cannot see another user's application as pupil" do
    user = FactoryGirl.create(:user, role: :pupil)
    another_user = FactoryGirl.create(:user)
    another_application = FactoryGirl.create(:application_letter, user: another_user)
    ability = Ability.new(user)


    expect(ability).to_not be_able_to(:show, another_application)
  end

  it "can see another user's application as coach" do
    user = FactoryGirl.create(:user, role: :coach)
    another_user = FactoryGirl.create(:user)
    another_application = FactoryGirl.create(:application_letter, user: another_user)
    ability = Ability.new(user)


    expect(ability).to be_able_to(:show, another_application)
  end

  %i[coach organizer].each do |role|

    it "can view and add notes to application letters as #{role}" do
      user = FactoryGirl.create(:user, role: role)
      ability = Ability.new(user)

      expect(ability).to be_able_to(:view_and_add_notes, ApplicationLetter)
      end

    it "can view applicants for an event as #{role}" do
      user = FactoryGirl.create(:user, role: role)
      ability = Ability.new(user)

      expect(ability).to be_able_to(:view_applicants, Event)
    end
  end

  it "cannot view and add notes to application letters as pupil" do
    user = FactoryGirl.create(:user, role: :pupil)
    ability = Ability.new(user)

    expect(ability).to_not be_able_to(:view_and_add_notes, ApplicationLetter)
  end

  it "cannot view applicants for an event as pupil" do
    user = FactoryGirl.create(:user, role: :pupil)
    ability = Ability.new(user)

    expect(ability).to_not be_able_to(:view_applicants, Event)
  end

  it "can do everything as admin" do
    user = FactoryGirl.create(:user, role: :admin)
    ability = Ability.new(user)

    expect(ability).to be_able_to(:manage, :all)
  end

  it "can only read profiles and applications as organizer" do
    user = FactoryGirl.create(:user, role: :organizer)
    another_user = FactoryGirl.create(:user)
    another_profile = FactoryGirl.create(:profile, user: another_user)
    another_application = FactoryGirl.create(:application_letter, user: another_user)
    ability = Ability.new(user)

    expect(ability).to be_able_to(:index, Profile)
    expect(ability).to be_able_to(:show, another_profile)
    expect(ability).to be_able_to(:index, ApplicationLetter)
    expect(ability).to be_able_to(:show, another_application)

    expect(ability).to_not be_able_to(:edit, another_profile)
    expect(ability).to_not be_able_to(:update, another_profile)
    expect(ability).to_not be_able_to(:destroy, another_profile)

    expect(ability).to_not be_able_to(:edit, another_application)
    expect(ability).to_not be_able_to(:update, another_application)
    expect(ability).to_not be_able_to(:destroy, another_application)
  end
end
