require "rails_helper"

RSpec.feature "Event application letters overview on event page", :type => :feature do
  before :each do
    @event = FactoryGirl.create(:event)
  end

  scenario "logged in as Pupil I can click the apply button on the index page" do
    @event.application_deadline = Date.tomorrow
    login(:pupil)
    visit events_path

    click_link I18n.t("helpers.links.apply")
    expect(page).to have_current_path(new_application_letter_path(:event_id => @event.id))
  end

  scenario "logged in as Pupil I can click the apply button on the show page" do
    @event.application_deadline = Date.tomorrow
    login(:pupil)
    visit event_path(@event)

    click_link I18n.t("helpers.links.apply")
    expect(page).to have_current_path(new_application_letter_path(:event_id => @event.id))
  end

  scenario "logged in as Pupil I can not see overview" do
    login(:pupil)
    visit event_path(@event)

    expect(page).to_not have_table("applicants")
    expect(page).to_not have_css("div#free_places")
    expect(page).to_not have_css("div#occupied_places")
  end

  scenario "logged in as Coach I can see overview" do
    login(:coach)
    visit event_path(@event)
    expect(page).to have_table("applicants")
    expect(page).to have_css("div#free_places")
    expect(page).to have_css("div#occupied_places")
  end

  scenario "logged in as Organizer I can see overview" do
    login(:organizer)
    visit event_path(@event)
    expect(page).to have_table("applicants")
    expect(page).to have_css("div#free_places")
    expect(page).to have_css("div#occupied_places")
  end

  scenario "comments on applications are displayed as comment icon tooltip, if there are any" do
    login(:organizer)
    event = FactoryGirl.create(:event, :with_one_application_note)
    visit event_path(event)
    expect(page).to have_css('.application-notes a.has-tooltip', count: 1)
    expect(page).to have_css(".application-notes a[title='#{event.application_letters.second.application_notes.first.note}']")
  end

  scenario "logged in as Organizer I want to be unable to send emails if there is any unclassified application left" do
    @event = FactoryGirl.build(:event, :with_diverse_open_applications, :in_selection_phase_with_no_mails_sent)
    login(:organizer)
    @event.update!(max_participants: 1)
    visit event_path(@event)
    expect(page).to have_css('button[disabled]', text: I18n.t('events.applicants_overview.sending_acceptances'))
    expect(page).to have_css('button[disabled]', text: I18n.t('events.applicants_overview.sending_rejections'))
  end

  scenario "logged in as Organizer I want to be unable to send emails if there is a negative number of free places left" do
    @event = FactoryGirl.create(:event, :in_selection_phase_with_no_mails_sent)
    login(:organizer)
    @event.update!(max_participants: 1)
    2.times do |n|
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      FactoryGirl.create(:application_letter, :accepted, :event => @event, :user => @pupil.user)
    end
    visit event_path(@event)
    expect(page).to have_css('button[disabled]', text: I18n.t('events.applicants_overview.sending_acceptances'))
    expect(page).to have_css('button[disabled]', text: I18n.t('events.applicants_overview.sending_rejections'))
  end


  scenario "logged in as Organizer I want to be able to send an email to all accepted applicants in selection phase" do
    @event = FactoryGirl.create(:event, :in_selection_phase_with_no_mails_sent)
    login(:organizer)
    @event.update!(max_participants: 2)
    2.times do |n|
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      FactoryGirl.create(:application_letter, :accepted, :event => @event, :user => @pupil.user)
    end
    visit event_path(@event)
    click_button I18n.t('events.applicants_overview.sending_acceptances')
    expect(page).to have_text(I18n.t('emails.email_form.show_recipients'))
    choose(I18n.t('emails.email_form.show_recipients'))
    fill_in('email_subject', with: 'Subject')
    fill_in('email_content', with: 'Content')
    expect{click_button I18n.t('emails.email_form.send')}.to change{ActionMailer::Base.deliveries.count}.by(1)
  end

  scenario "logged in as Organizer I want to be able to send an email to all rejected applicants in selection phase" do
    @event = FactoryGirl.create(:event, :in_selection_phase_with_no_mails_sent)
    login(:organizer)
    @event.update!(max_participants: 2)
    2.times do |n|
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      FactoryGirl.create(:application_letter, :rejected, :event => @event, :user => @pupil.user)
    end
    visit event_path(@event)
    click_button I18n.t('events.applicants_overview.sending_rejections')
    expect(page).to have_text(I18n.t('emails.email_form.show_recipients'))
    choose(I18n.t('emails.email_form.show_recipients'))
    fill_in('email_subject', with: 'Subject')
    fill_in('email_content', with: 'Content')
    expect{click_button I18n.t('emails.email_form.send')}.to change{ActionMailer::Base.deliveries.count}.by(1)
  end

  scenario "logged in as Organizer I can see the correct count of free/occupied places" do
    login(:organizer)
    @event.update!(max_participants: 1)
    visit event_path(@event)
    expect(page).to have_text(I18n.t "free_places", count: (@event.max_participants).to_i, scope: [:events, :applicants_overview])
    expect(page).to have_text(I18n.t "occupied_places", count: 0, scope: [:events, :applicants_overview])
    2.times do |i| #2 to also test negative free places, those are fine
      @pupil = FactoryGirl.create(:profile)
      @pupil.user.role = :pupil
      @application_letter = FactoryGirl.create(:application_letter, :accepted, event: @event, user: @pupil.user)
      visit event_path(@event)
      expect(page).to have_text(I18n.t "free_places", count: (@event.max_participants).to_i - (i+1), scope: [:events, :applicants_overview])
      expect(page).to have_text(I18n.t "occupied_places", count: (i+1), scope: [:events, :applicants_overview])
    end
  end

  scenario "logged in as Organizer I can change application status with radio buttons in selection phase" do
    login(:organizer)
    @event = FactoryGirl.create(:event, :with_open_application, :in_selection_phase_with_no_mails_sent)
    visit event_path(@event)
    ApplicationLetter.selectable_statuses.each do |new_status|
      choose(I18n.t "application_status.#{new_status}")
      expect(ApplicationLetter.where(id: @event.application_letters.first.id)).to exist
    end
  end

  scenario "logged in as Organizer I can change application status with radio buttons without the page reloading in selection phase", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event, :with_open_application, :in_selection_phase_with_no_mails_sent)
    visit event_path(@event)
    find('label', text: I18n.t('application_status.accepted')).click
    check_values = lambda {
      expect(page).to have_text(I18n.t "free_places", count: (@event.max_participants).to_i - 1, scope: [:events, :applicants_overview])
      expect(page).to have_text(I18n.t "occupied_places", count: 1, scope: [:events, :applicants_overview])
    }

    check_values.call
    # verify that the state was actually persisted by reloading the page
    visit event_path(@event)
    check_values.call
    expect(page).to have_css('label.active', text: I18n.t('application_status.accepted'))
  end

  scenario "logged in as Organizer I can not change application status with radio buttons if acceptance emails or rejection emails have been sent" do
    login(:organizer)
    [[true, true], [true, false], [false, true]].each do |acceptances_have_been_sent, rejections_have_been_sent|
      @event.acceptances_have_been_sent = acceptances_have_been_sent
      @event.rejections_have_been_sent = rejections_have_been_sent
      @pupil = FactoryGirl.create(:profile)
      @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
      visit event_path(@event)
      ApplicationLetter.statuses.keys.each do |new_status|
        if new_status != @application_letter.status
          expect(page).not_to have_css('label', text: I18n.t("application_status.#{new_status}"))
        end
      end
    end
  end

  scenario "logged in as Organizer I can cancel accepted applications (execution phase) when status notification was sent" do
    login(:organizer)
    @event = FactoryGirl.create(:event_in_execution_with_applications_in_various_states, :with_status_notification_sent, accepted_application_letters_count: 1)
    @application_letter = @event.application_letters.find { |application| application.status == 'accepted'}
    visit event_path(@event)
    expect(page).to have_link(I18n.t("application_status.actions.cancel"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))
    click_link I18n.t "application_status.actions.cancel"
    expect(page).to_not have_link(I18n.t("application_status.actions.cancel"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))
    @application_letter.reload
    expect(@application_letter.status).to eq('canceled')
    expect(@application_letter.status_notification_sent).to be false
    expect(page).to_not have_css('span.glyphicon-envelope')
  end

  scenario "logged in as Organizer I cannot cancel accepted applications (execution phase) when status notification was not sent" do
    login(:organizer)
    @event = FactoryGirl.create(:event_in_execution_with_applications_in_various_states, :with_no_status_notification_sent, accepted_application_letters_count: 1)
    @application_letter = @event.application_letters.find { |application| application.status == 'accepted'}
    visit event_path(@event)
    expect(page).to_not have_link(I18n.t("application_status.actions.cancel"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))
    expect(page).to have_css('span.glyphicon-envelope')
  end

  scenario "logged in as Organizer I can accept alternative applications (execution phase)" do
    login(:organizer)
    @event = FactoryGirl.create(:event_in_execution_with_applications_in_various_states, :with_status_notification_sent, alternative_application_letters_count: 1)
    @application_letter = @event.application_letters.find { |application| application.status == 'alternative'}
    visit event_path(@event)
    expect(page).to have_link(I18n.t("application_status.actions.accept"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
    click_link I18n.t "application_status.actions.accept"
    expect(page).to_not have_link(I18n.t("application_status.actions.accept"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
    expect(page).to have_css('span.glyphicon-envelope', count: 1)
    expect(page).to_not have_link(I18n.t('application_status.actions.cancel'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))
    @application_letter.reload
    expect(@application_letter.status).to eq('accepted')
    expect(@application_letter.status_notification_sent).to be false
  end

  scenario "logged in as Organizer I cannot accept alternative applications if no free places are available (execution phase)" do
    login(:organizer)
    @event = FactoryGirl.create(:event_in_execution_with_applications_in_various_states, accepted_application_letters_count: 2, alternative_application_letters_count: 1, max_participants: 2)
    @application_letter = @event.application_letters.find { |application| application.status == 'alternative'}
    visit event_path(@event)
    expect(page).to_not have_link(I18n.t("application_status.actions.accept"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end

  scenario "logged in as Organizer I can accept rejected applications (execution phase) when there are no alternative applications" do
    login(:organizer)
    @event = FactoryGirl.create(:event_in_execution_with_applications_in_various_states, :with_status_notification_sent, alternative_application_letters_count: 0, rejected_application_letters_count: 1)
    @application_letter = @event.application_letters.find { |application| application.status == 'rejected'}
    visit event_path(@event)
    expect(page).to have_link(I18n.t("application_status.actions.accept"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
    click_link I18n.t "application_status.actions.accept"
    expect(page).to_not have_link(I18n.t("application_status.actions.accept"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
    expect(page).to have_css('span.glyphicon-envelope', count: 1)
    expect(page).to_not have_link(I18n.t('application_status.actions.cancel'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))
    @application_letter.reload
    expect(@application_letter.status).to eq('accepted')
    expect(@application_letter.status_notification_sent).to be false
  end

  scenario "logged in as Organizer I cannot accept rejected applications (execution phase) when there are alternative applications" do
    login(:organizer)
    @event = FactoryGirl.create(:event_in_execution_with_applications_in_various_states, alternative_application_letters_count: 1, rejected_application_letters_count: 1)
    @application_letter = @event.application_letters.find { |application| application.status == 'rejected'}
    visit event_path(@event)
    expect(page).to_not have_link(I18n.t("application_status.actions.accept"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end

  scenario "logged in as Organizer I cannot accept rejected applications if no free places are available (execution phase)" do
    login(:organizer)
    @event = FactoryGirl.create(:event_in_execution_with_applications_in_various_states, accepted_application_letters_count: 2, alternative_application_letters_count: 0, rejected_application_letters_count: 1, max_participants: 2)
    @application_letter = @event.application_letters.find { |application| application.status == 'rejected'}
    visit event_path(@event)
    expect(page).to_not have_link(I18n.t("application_status.actions.accept"), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end

  scenario "logged in as Organizer I can send emails to accepted alternatives who got no acceptance mail yet (execution phase)" do
    login(:organizer)
    @event = FactoryGirl.create(:event_in_execution_with_applications_in_various_states, :with_no_status_notification_sent, accepted_application_letters_count: 1)
    @application_letter = @event.application_letters.find { |application| application.status == 'accepted'}
    visit event_path(@event)
    expect(page).to have_button(I18n.t('events.applicants_overview.sending_acceptances'))
    click_button(I18n.t('events.applicants_overview.sending_acceptances'))
    expect(page).to have_selector("input#email_recipients[value='#{@application_letter.user.email}']")
  end

  scenario "logged in as Organizer I can send acceptance and then rejection emails and by that change the status notification flag  (without alternatives)" do
    login(:organizer)
    event = FactoryGirl.create(:event_with_accepted_applications, :in_selection_phase_with_no_mails_sent, :with_no_status_notification_sent)
    %w[accepted rejected].each do |status|
      applications = event.application_letters.select { | application_letter | application_letter.status == status }
      expect(applications.size).to be > 0
      visit event_path(event)
      send_email_button_label = (status == 'accepted') ? 'sending_acceptances' : 'sending_rejections'
      click_button(I18n.t("events.applicants_overview.#{send_email_button_label}"))
      expect(page).to have_current_path(event_email_show_path(event_id: event.id), only_path: true)
      fill_in :email_subject, with: "Subject #{status}"
      fill_in :email_content, with: "Content #{status}"
      click_button I18n.t('.emails.email_form.send')
      applications.each do |letter|
        letter.reload
        expect(letter.status_notification_sent).to be true
      end
    end
  end

  scenario "logged in as Organizer I can send alternative emails (treated like rejections) and by that change the status notification flag" do
    login(:organizer)
    event = FactoryGirl.create(:event_with_accepted_applications, :in_selection_phase_with_no_mails_sent, :with_no_status_notification_sent)
    application = FactoryGirl.create(:application_letter, :alternative, event: event, user: FactoryGirl.build(:user))
    visit event_path(event)
    click_button(I18n.t("events.applicants_overview.sending_rejections"))
    expect(page).to have_current_path(event_email_show_path(event_id: event.id), only_path: true)
    fill_in :email_subject, with: "Subject alternative"
    fill_in :email_content, with: "Content alternative"
    click_button I18n.t('.emails.email_form.send')
    application.reload
    expect(application.status_notification_sent).to be true
  end

  scenario "logged in as Organizer I can push the accept all button to accept all applicants" do
    @event = FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase_with_no_mails_sent)
    @event.max_participants = @event.application_letters.size + 1
    @event.save
    login(:organizer)
    visit event_path(@event)
    click_link I18n.t "events.applicants_overview.accept_all"
    application_letters = ApplicationLetter.where(event: @event.id)
    expect(application_letters.all? { |application_letter| application_letter.status == 'accepted' }).to eq(true)
  end

  scenario "logged in as Organizer and viewing the participants page all checkboxes are checked when pressing the \"check all\" button", js: true do
    login(:organizer)
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, user: @user, birth_date: 15.years.ago)
    @event = FactoryGirl.create(:event)
    @application = FactoryGirl.create(:application_letter, :accepted, user: @user, event: @event)
    @agreement = FactoryGirl.create(:agreement_letter, user: @user, event: @event)
    visit event_participants_path(@event)
    check 'select_all_participants'
    all('input[type=checkbox]').each do |checkbox|
      expect(checkbox).to be_checked
    end
  end

  scenario "logged in as Organizer when I want to download agreement letters but no participants are selected, it displays error message", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
    visit event_participants_path(@event)
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page).to have_text(I18n.t "events.agreement_letters_download.notices.no_participants_selected")
  end

  scenario "logged in as Organizer when I want to download agreement letters but no participants have agreement letters, it displays error message", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
    visit event_participants_path(@event)
    find(:css, "#selected_participants_[value='2']").click
    find("option[value='zip']").select_option
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page).to have_text(I18n.t "events.agreement_letters_download.notices.no_agreement_letters")
    visit event_participants_path(@event)
    find(:css, "#selected_participants_[value='2']").click
    find("option[value='pdf']").select_option
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page).to have_text(I18n.t "events.agreement_letters_download.notices.no_agreement_letters")
  end

  scenario "logged in as Organizer when I want to download agreement letters in a zip file, I can do so", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
    visit event_participants_path(@event)
    check 'select_all_participants'
    find("option[value='zip']").select_option
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page.response_headers['Content-Type']).to eq("application/zip")
  end

  scenario "logged in as Organizer when I want to download agreement letters in a pdf file, I can do so", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_accepted_applications_and_agreement_letters)
    visit event_participants_path(@event)
    check 'select_all_participants'
    find("option[value='pdf']").select_option
    click_button I18n.t "events.agreement_letters_download.download_all_as"
    expect(page.response_headers['Content-Type']).to eq("application/pdf")
  end

  scenario "logged in as Coach I can see application status" do
    login(:coach)
    @pupil = FactoryGirl.create(:profile)
    @application_letter = FactoryGirl.create(:application_letter, event: @event, user: @pupil.user)
    visit event_path(@event)
    expect(page).to have_text(I18n.t "application_status.#{@application_letter.status}")
  end

  scenario "Logged in as organizer I can see a table with the applicants and sort them by attributes" do
    login(:organizer)
    @event = FactoryGirl.create(:event)
    visit event_path(@event)

    table = page.find(:xpath, '//table[@id="applicants"]')
    @event.application_letters.each do |application_letter|
      expect(table).to have_text(application_letter.user.profile.name)
    end

    ['name', 'gender'].each do |attribute|
      link_name = I18n.t("activerecord.attributes.profile.#{attribute}")
      click_link link_name
      sorted_by_attribute = @event.application_letters.to_a.sort_by { |letter| letter.user.profile.send(attribute) }
      names = sorted_by_attribute.map {|l| l.user.profile.name }
      expect(page).to contain_ordered(names)

      click_link link_name # again
      expect(page).to contain_ordered(names.reverse)
    end

    link_name = I18n.t('events.applicants_overview.age_when_event_starts')
    click_link link_name
    sorted_by_attribute = @event.application_letters.to_a.sort_by { |letter| letter.send(attribute) }
    names = sorted_by_attribute.map {|l| l.user.profile.name }
    expect(page).to contain_ordered(names)

    click_link link_name # again
    expect(page).to contain_ordered(names.reverse)
  end

  scenario "logged in as Organizer I can filter displayed application letters by their status and simultaneously sort them", js: true do
    login(:organizer)
    @event = FactoryGirl.create(:event_with_applications_in_various_states)

    visit event_path(@event)
    click_button I18n.t 'events.applicants_overview.filter_by'
    check I18n.t 'application_status.accepted'
    click_button I18n.t 'events.applicants_overview.filter'
    accepted_names = @event.application_letters.to_a.select { |l| l.status.to_sym == :accepted }.map {|l| l.user.profile.name}
    not_accepted_names = @event.application_letters.to_a.select { |l| l.status.to_sym != :accepted }.map {|l| l.user.profile.name}

    expect(page).to have_every_text(accepted_names)
    expect(page).to have_no_text(not_accepted_names)

    # sort this list by name
    click_link I18n.t('activerecord.attributes.profile.name')
    expect(page).to have_css('a.dropup')

    sorted_accepted_names = @event.application_letters
      .to_a
      .sort_by { |letter| letter.user.profile.name }
      .select { |letter| letter.status.to_sym == :accepted }
      .map {|letter| letter.user.profile.name }
    expect(page).to contain_ordered(sorted_accepted_names)

    # list all others
    click_button I18n.t 'events.applicants_overview.filter_by'
    uncheck I18n.t 'application_status.accepted'
    check I18n.t 'application_status.rejected'
    check I18n.t 'application_status.pending'
    check I18n.t 'application_status.alternative'
    check I18n.t 'application_status.canceled'
    click_button I18n.t 'events.applicants_overview.filter'

    expect(page).to have_every_text(not_accepted_names)
    expect(page).to have_no_text(accepted_names)
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end
