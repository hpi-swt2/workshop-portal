require "rails_helper"
require "object_creation_helper"

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
    names = sorted_by_group.map {|p| (p.email)}
    expect(page).to contain_ordered(names)

    click_link link_name # again
    expect(page).to contain_ordered(names.reverse)


  end

  scenario "logged in as anOrganizer I want to be able to sort the participants table by their eating habits" do
    # Peter, vegan
    pe = create_accepted_application_with(@event, "Peter", false, true, false)

    # Paul, vegan, allergic
    pa = create_accepted_application_with(@event, "Paul", true, true, false)

    # Mary, vegetarian
    ma = create_accepted_application_with(@event, "Mary", false, false, true)

    # Otti, vegetarian, allergic
    ot = create_accepted_application_with(@event, "Otti", true, false, true)

    # Benno, none
    be = create_accepted_application_with(@event, "Benno", false, false, false)

    #Expected Sorting Order
    #Benno, Mary, Peter, Otti, Paul ASC
    #Paul, Otti, Peter, Mary, Benno DESC

    expected_order = [be.user.email, ma.user.email, pe.user.email, ot.user.email, pa.user.email]

    login(:organizer)
    visit event_participants_path(@event)
    link_name = I18n.t('activerecord.methods.application_letter.eating_habits')

    click_link link_name
    expect(page.body).to contain_ordered(expected_order)

    click_link link_name
    expect(page.body).to contain_ordered(expected_order.reverse)

  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end

RSpec.feature "Event participants overview", :type => :feature do
  before :each do
    @event = FactoryGirl.create(:event)
    @users = []
    for i in 1..5
      user = FactoryGirl.create(:user)
      @users.push(user)
      profile = FactoryGirl.create(:profile, user: user, last_name: i.to_s)
      application_letter = FactoryGirl.create(:application_letter_accepted, user: user, event: @event)
      participant_group = FactoryGirl.create(:participant_group, user: user, event: @event, group: i)
    end
  end

  scenario "logged in as Organizer I want to be able to send an email to all participants" do
    login(:organizer)
    emails = @users.map {|user| user.email}
    visit event_participants_path(@event)
    check :all
    click_button(I18n.t('events.email_modal.send_email_label'))
    fill_in('email_reply_to', with: Rails.configuration.reply_to_address)
    fill_in('email_subject', with: 'Subject')
    fill_in('email_content', with: 'Content')
    expect(find_field('email_recipients').value).to include(*emails)
    expect{click_button I18n.t('emails.email_form.send')}.to change{ActionMailer::Base.deliveries.count}.by(1)
    expect(page).to have_text(I18n.t('emails.submit.sending_successful'))
  end

  scenario "logged in as Organizer I cant send an invalid email to all participants" do
    login(:organizer)
    visit event_participants_path(@event)
    check :all
    # Email has no sender yet, because no sender is set. Should cause the sending to fail.
    click_button(I18n.t('events.email_modal.send_email_label'))
    fill_in('email_subject', with: 'Subject')
    fill_in('email_content', with: 'Content')
    expect{click_button I18n.t('emails.email_form.send')}.to change{ActionMailer::Base.deliveries.count}.by(0)
    expect(page).to have_text(I18n.t('emails.submit.sending_failed'))
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end