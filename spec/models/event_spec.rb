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

  let(:event) { FactoryGirl.create :event, :with_two_date_ranges }


  it "can't be created without mandatory fields" do
    [:hidden, :application_deadline].each do |attr|
      event = FactoryGirl.build(:event, attr => nil)
      expect(event).to_not be_valid
    end
  end

  it "is created by event factory" do
    expect(event).to be_valid
  end

  it "has as many participants as accepted applications" do
    event = FactoryGirl.create(:event_with_accepted_applications, accepted_application_letters_count: 10, rejected_application_letters_count: 7)
    expect(event.participants.length).to eq 10
  end

  it "sorts participants in the expected order" do
    @event = FactoryGirl.create(:event)
    @user1 = FactoryGirl.create(:user, email: 'ghk@example.com')
    @profile1 = FactoryGirl.create(:profile, user: @user1, birth_date: 15.years.ago)
    @application1 = FactoryGirl.create(:application_letter_accepted, user: @user1, event: @event)
    @agreement1 = FactoryGirl.create(:agreement_letter, user: @user1, event: @event)

    @user2 = FactoryGirl.create(:user, email: 'bba@example.com')
    @profile2 = FactoryGirl.create(:profile, user: @user2, birth_date: 16.years.ago)
    @application2 = FactoryGirl.create(:application_letter_accepted, user: @user2, event: @event)

    @user3 = FactoryGirl.create(:user, email: 'eee@example.com')
    @profile3 = FactoryGirl.create(:profile, user: @user3, birth_date: 19.years.ago)
    @application3 = FactoryGirl.create(:application_letter_accepted, user: @user3, event: @event)
    @agreement3 = FactoryGirl.create(:agreement_letter, user: @user3, event: @event)

    @user4 = FactoryGirl.create(:user, email: 'ddd@example.com')
    @profile4 = FactoryGirl.create(:profile, user: @user4, birth_date: 16.years.ago)
    @application4 = FactoryGirl.create(:application_letter_accepted, user: @user4, event: @event)

    @user5 = FactoryGirl.create(:user, email: 'bbb@example.com')
    @profile5 = FactoryGirl.create(:profile, user: @user5, birth_date: 20.years.ago)
    @application5 = FactoryGirl.create(:application_letter_accepted, user: @user5, event: @event)

    @user6 = FactoryGirl.create(:user, email: 'abc@example.com')

    @profile6 = FactoryGirl.create(:profile, user: @user6, birth_date: 16.years.ago)
    @application6 = FactoryGirl.create(:application_letter_accepted, user: @user6, event: @event)
    @agreement6 = FactoryGirl.create(:agreement_letter, user: @user6, event: @event)
    #2,4,6,1,5,3
  expect(@event.participants_by_agreement_letter).to eq([@user2, @user4, @user6, @user1, @user5, @user3])
  end

  it "saves custom application fields serialized to the database" do
    array = ['Field 1', 'Field 2']
    event = FactoryGirl.create(:event, custom_application_fields: array)
    expect(event.custom_application_fields).to eq(array)
  end

  it "checks if there are unclassified applications_letters" do
    event = FactoryGirl.create(:event)
    accepted_application_letter = FactoryGirl.create(:application_letter_accepted, :event => event, :user => FactoryGirl.create(:user))
    event.application_letters.push(accepted_application_letter)
    expect(event.applications_classified?).to eq(true)

    pending_application_letter = FactoryGirl.create(:application_letter, :event => event, :user => FactoryGirl.create(:user))
    event.application_letters.push(pending_application_letter)
    expect(event.applications_classified?).to eq(false)
  end

  it "computes the email addresses of the accepted and the rejected applications" do
    event = FactoryGirl.create(:event)
    accepted_application_letter_1 = FactoryGirl.create(:application_letter_accepted, :event => event, :user => FactoryGirl.create(:user))
    accepted_application_letter_2 = FactoryGirl.create(:application_letter_accepted, :event => event, :user => FactoryGirl.create(:user))
    accepted_application_letter_3 = FactoryGirl.create(:application_letter_accepted, :event => event, :user => FactoryGirl.create(:user))
    rejected_application_letter = FactoryGirl.create(:application_letter_rejected, :event => event, :user => FactoryGirl.create(:user))
    [accepted_application_letter_1, accepted_application_letter_2, accepted_application_letter_3, rejected_application_letter].each { |letter| event.application_letters.push(letter) }
    expect(event.email_addresses_of_type(:accepted)).to eq([accepted_application_letter_1.user.email, accepted_application_letter_2.user.email, accepted_application_letter_3.user.email].join(','))
    expect(event.email_addresses_of_type(:rejected)).to eq([rejected_application_letter.user.email].join(','))
  end

  it "is either a camp or a workshop" do
    expect { FactoryGirl.build(:event, kind: :smth_invalid) }.to raise_error(ArgumentError)

    event = FactoryGirl.build(:event, kind: :camp)
    expect(event).to be_valid

    event = FactoryGirl.build(:event, kind: :workshop)
    expect(event).to be_valid
  end

  it "should have one or more date-ranges" do

    #checking if the event model can handle date_ranges
    expect(event.date_ranges.size).to eq 2
    expect(event.date_ranges.first.start_date).to eq(Date.tomorrow.next_day(1))
    expect(event.date_ranges.first.end_date).to eq(Date.tomorrow.next_day(5))
    expect(event.date_ranges.second.start_date).to eq(Date.tomorrow.next_day(1))
    expect(event.date_ranges.second.end_date).to eq(Date.tomorrow.next_day(10))
    expect(event.date_ranges.second).to eq(event.date_ranges.last)

    #making sure that every event has at least one date range
    event1 = FactoryGirl.build(:event, :without_date_ranges)
    expect(event1).to_not be_valid
  end

  describe "#start_date" do
    it "should return return its minimum over all date ranges" do
      event = FactoryGirl.create :event, :with_multiple_date_ranges
      expect(event.start_date).to eq(Date.tomorrow)
    end
  end

  describe "#end_date" do
    it "should return return its maximum over all date ranges" do
      event = FactoryGirl.create :event, :with_multiple_date_ranges
      expect(event.end_date).to eq(Date.current.next_day(16))
    end
  end

  describe "#unreasonably_long" do
    it "should be true if the event is longer than defined" do
      event = FactoryGirl.create :event, :with_unreasonably_long_range
      expect(event.unreasonably_long).to be true
    end
  end

  it "returns the event's participants" do
    event = FactoryGirl.build(:event)
    FactoryGirl.create(:application_letter_rejected, event: event)
    accepted_letter = FactoryGirl.create(:application_letter_accepted, event: event)
    expect(event.participants).to eq [accepted_letter.user]
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
    expect(event.compute_occupied_places).to eq(1)
    application_letter_accepted_2 = FactoryGirl.create(:application_letter_accepted, user: FactoryGirl.create(:user), event: event)
    expect(event.compute_occupied_places).to eq(2)
  end

  describe "returns applicants email list" do
    before :each do
      @event = FactoryGirl.create(:event)
    end
    
    it "returns email address only of the given type" do
      @accepted_application = FactoryGirl.create(:application_letter_accepted, event: @event, user: FactoryGirl.create(:user))
      @rejected_application = FactoryGirl.create(:application_letter_rejected, event: @event, user: FactoryGirl.create(:user))
      expect(@event.email_addresses_of_type(:accepted)).to eq(@accepted_application.user.email)
      expect(@event.email_addresses_of_type(:rejected)).to eq(@rejected_application.user.email)
    end

    it "correctly concatinates multiple email addresses" do
      @application1 = FactoryGirl.create(:application_letter_accepted, event: @event, user: FactoryGirl.create(:user))
      @application2 = FactoryGirl.create(:application_letter_accepted, event: @event, user: FactoryGirl.create(:user))
      expect(@event.email_addresses_of_type(:accepted)).to eq(@application1.user.email + "," + @application2.user.email)
    end
  end
  
  it "generates an application letter list ordered by first name" do
    @event = FactoryGirl.create(:event)
    @user1 = FactoryGirl.create(:user, email:'a@b.com')
    @profile1 = FactoryGirl.create(:profile, user: @user1, birth_date: 15.years.ago, first_name:'Corny')
    @application1 = FactoryGirl.create(:application_letter_accepted, user: @user1, event: @event)
    @agreement1 = FactoryGirl.create(:agreement_letter, user: @user1, event: @event)

    @user2 = FactoryGirl.create(:user, email:'b@c.com')
    @profile2 = FactoryGirl.create(:profile, user: @user2, birth_date: 16.years.ago, first_name:'John')
    @application2 = FactoryGirl.create(:application_letter_accepted, user: @user2, event: @event)

    expect(@event.application_letters_ordered('first_name','asc')).to eq([@application1,@application2])
  end

  it "generates an application letter list ordered by anything else" do
    @event = FactoryGirl.create(:event)
    @user1 = FactoryGirl.create(:user, email:'a@b.com')
    @profile1 = FactoryGirl.create(:profile, user: @user1, birth_date: 15.years.ago, first_name:'Corny')
    @application1 = FactoryGirl.create(:application_letter_accepted, user: @user1, event: @event)
    @agreement1 = FactoryGirl.create(:agreement_letter, user: @user1, event: @event)

    @user2 = FactoryGirl.create(:user, email:'b@c.com')
    @profile2 = FactoryGirl.create(:profile, user: @user2, birth_date: 16.years.ago, first_name:'John')
    @application2 = FactoryGirl.create(:application_letter_accepted, user: @user2, event: @event)

    expect(@event.application_letters_ordered('unknown','desc')).to eq([@application2,@application1])
  end

  it "accepts all its application letters" do
    event = FactoryGirl.create :event, :with_diverse_open_applications
    event.accept_all_application_letters
    application_letters = ApplicationLetter.where(event: event.id)
    expect(application_letters.all? { |application_letter| application_letter.status == 'accepted' }).to eq(true)
  end

  it "locks the application status changing of the event" do
    event = FactoryGirl.create(:event)
    event.application_status_locked = false
    event.save
    event.lock_application_status
    expect(event.application_status_locked).to eq(true)
  end

  it "is in draft phase" do
    event = FactoryGirl.build(:event, :in_draft_phase)
    expect(event.phase).to eq(:draft)
  end

  it "is in application phase" do
    event = FactoryGirl.build(:event, :in_application_phase)
    expect(event.phase).to eq(:application)
  end

  it "is in selection phase" do
    event = FactoryGirl.build(:event, :in_selection_phase)
    expect(event.phase).to eq(:selection)
  end

  it "is in execution phase" do
    event = FactoryGirl.build(:event, :in_execution_phase)
    expect(event.phase).to eq(:execution)
  end

  it "is not after application deadline" do
    event = FactoryGirl.build(:event)
    event.application_deadline = Date.tomorrow
    expect(event.after_deadline?).to eq(false)
  end

  it "is after application deadline" do
    event = FactoryGirl.build(:event)
    event.application_deadline = Date.yesterday
    expect(event.after_deadline?).to eq(true)
  end

  it "can have unlimited participants" do
    event = FactoryGirl.create(:event)
    event.max_participants = Float::INFINITY
    expect(event.participants_are_unlimited).to be(true)
  end

  it "has infinite max participants if max participants is unlimited" do
    event = FactoryGirl.create(:event)
    event.participants_are_unlimited = true
    expect(event.max_participants).to be(Float::INFINITY)
  end
end
