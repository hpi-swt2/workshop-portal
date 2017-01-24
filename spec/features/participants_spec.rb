require "rails_helper"

RSpec.feature "Event participants overview", :type => :feature do
  before :each do
    @event = FactoryGirl.create(:event)
  end

  scenario "logged in as Organizer I can sucessfully select a group for a participant", js: true do
    login(:organizer)
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, user: @user)
    @application_letter = FactoryGirl.create(:application_letter_accepted, user: @user, event: @event)
    visit event_participants_path(@event)
    select I18n.t("participant_groups.options.#{ParticipantGroup::GROUPS[9]}"), from: "participant_group[group]", match: :first, visible: false
    expect(page).to have_text(I18n.t("participant_groups.update.successful"))
    expect(page).to have_select('participant_group_group', { selected: I18n.t("participant_groups.options.#{ParticipantGroup::GROUPS[9]}"), match: :first, visible: false })
  end

  scenario "logged in as Organizer I can see a table with the participants and sort them by group" do
    login(:organizer)
    for i in 1..5
      user = FactoryGirl.create(:user)
      profile = FactoryGirl.create(:profile, user: user, last_name: i.to_s)
      application_letter = FactoryGirl.create(:application_letter_accepted, user: user, event: @event)
      participant_group = FactoryGirl.create(:participant_group, user: user, event: @event, group: i)
    end

    visit event_participants_path(@event)

    table = page.find('table')
    @event.participants.each do |participant|
      expect(table).to have_text(participant.profile.name)
    end

    link_name = I18n.t("activerecord.attributes.participant_group.group")
    click_link link_name
    sorted_by_group = @event.participants.sort_by {|p| @event.participant_group_for(p).group }
    names = sorted_by_group.map {|p| p.profile.name }
    expect(page).to contain_ordered(names)

    click_link link_name # again
    expect(page).to contain_ordered(names.reverse)


  end

  scenario "logged in as an Organizer I want to be able to sort the participants table by their eating habits" do
    user = FactoryGirl.create(:user)
    profile = FactoryGirl.create(:profile, user: user, last_name: "Peter")
    application_letter = FactoryGirl.create(:application_letter_accepted, 
      user: user, event: @event, vegan: true)
    user = FactoryGirl.create(:user)
    profile = FactoryGirl.create(:profile, user: user, last_name: "Paul")
    application_letter = FactoryGirl.create(:application_letter_accepted, 
      user: user, event: @event, vegan: true, allergic: true)
    user = FactoryGirl.create(:user)
    profile = FactoryGirl.create(:profile, user: user, last_name: "Mary")
    application_letter = FactoryGirl.create(:application_letter_accepted, 
      user: user, event: @event, vegetarian: true)
    user = FactoryGirl.create(:user)
    profile = FactoryGirl.create(:profile, user: user, last_name: "Otti")
    application_letter = FactoryGirl.create(:application_letter_accepted, 
      user: user, event: @event, vegetarian: true, allergic: true)
    user = FactoryGirl.create(:user)
    profile = FactoryGirl.create(:profile, user: user, last_name: "Benno")
    application_letter = FactoryGirl.create(:application_letter_accepted, 
      user: user, event: @event)

    #Expected Sorting Order
    #Benno, Mary, Peter, Otti, Paul ASC
    #Paul, Otti, Peter, Mayr, Benno DESC
    
    

    sorted_by_eating_habit = @event.participants.sort! do |a,b| 
      a = ApplicationLetter.find_by(user_id: a.id, event_id: @event.id)
      b = ApplicationLetter.find_by(user_id: b.id, event_id: @event.id)
      a.get_eating_habit_state <=> b.get_eating_habit_state     
    end

    names = sorted_by_eating_habit.map {|p| p.profile.name}

    login(:organizer)
    visit event_participants_path(@event)
    link_name = I18n.t('activerecord.methods.application_letter.eating_habits')
    click_link link_name

    expect(page).to contain_ordered(names)
    click_link link_name
    expect(page).to contain_ordered(names.reverse)


  end


  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end
