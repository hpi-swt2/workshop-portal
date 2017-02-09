require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryGirl.create(:event, :with_two_date_ranges))
    @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user_with_profile, role: :organizer), event: @event)
    @application_letters = @event.application_letters
    @material_files = ["spec/testfiles/actual.pdf"]
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(@application_letter.user)
  end

  it "renders attributes" do
    render
    expect(rendered).to have_text(@event.name)
    expect(rendered).to have_text(@event.description)
    expect(rendered).to have_text(@event.max_participants)
    expect(rendered).to have_text(@event.organizer)
    expect(rendered).to have_text(@event.knowledge_level)
  end

  it "does not render knowledge level or organizer if empty and the user isn't organizer" do
    @event = assign(:event, FactoryGirl.create(:event, knowledge_level: '', organizer: ''))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :pupil))

    render
    expect(rendered).to_not have_text(Event.human_attribute_name(:knowledge_level))
    expect(rendered).to_not have_text(Event.human_attribute_name(:organizer))
  end

  it "does not render knowledge level or organizer if nil and the user isn't organizer" do
    @event = assign(:event, FactoryGirl.create(:event, knowledge_level: nil, organizer: nil))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :pupil))

    render
    expect(rendered).to_not have_text(Event.human_attribute_name(:knowledge_level))
    expect(rendered).to_not have_text(Event.human_attribute_name(:organizer))
  end

  it "does render knowledge level or organizer if empty and the user is organizer" do
    @event = assign(:event, FactoryGirl.create(:event, knowledge_level: '', organizer: ''))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))

    render
    expect(rendered).to have_text(Event.human_attribute_name(:knowledge_level))
    expect(rendered).to have_text(Event.human_attribute_name(:organizer))
  end

  it "displays counter" do
    free_places = assign(:free_places, @event.compute_free_places)
    occupied_places = assign(:occupied_places, @event.compute_occupied_places)
    render
    expect(rendered).to have_text(I18n.t 'free_places', count: free_places, scope: [:events, :applicants_overview])
    expect(rendered).to have_text(I18n.t 'occupied_places', count: occupied_places, scope: [:events, :applicants_overview])
  end

  it "renders applicants table" do
    render
    expect(rendered).to have_table("applicants")
  end

  it "renders applicants table header fields" do
    render
    expect(rendered).to have_css("th", :text => t(:name, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:gender, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:age, scope:'activerecord.attributes.profile'))
    expect(rendered).to have_css("th", :text => t(:participations, scope: 'events.applicants_overview'))
    expect(rendered).to have_css("th", :text => t(:status, scope: 'events.applicants_overview'))
  end

  it "displays applicants information" do
    render
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.name)
    expect(rendered).to have_css("td", :text => I18n.t("profiles.genders.#{@application_letter.user.profile.gender}"))
    expect(rendered).to have_css("td", :text => @application_letter.user.profile.age_at_time(@event.start_date))
  end

  it "logged in as organizer it renders radio buttons for accept reject pending and alternative, but not canceled in selection phase" do
    sign_in(FactoryGirl.create(:user, role: :organizer))
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase_with_no_mails_sent))
    assign(:has_free_places, @event.compute_free_places > 0)
    @application_letters = @event.application_letters #TODO I couldnt find a assign(:application_letters), still this gives the view access to it.
    render
    expect(rendered).to have_css("label", text: I18n.t('application_status.accepted'))
    expect(rendered).to have_css("label", text: I18n.t('application_status.rejected'))
    expect(rendered).to have_css("label", text: I18n.t('application_status.pending'))
    expect(rendered).to have_css("label", text: I18n.t('application_status.alternative'))
    expect(rendered).to_not have_css("label", text: I18n.t('application_status.canceled'))
  end

  it "displays application details button" do
    render
    expect(rendered).to have_link(t(:details, scope: 'events.applicants_overview'))
  end

  it "should warn about unreasonably long time spans for organizers" do
    @event = assign(:event, FactoryGirl.create(:event, :with_unreasonably_long_range))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_text(I18n.t 'events.notices.unreasonable_timespan')
  end

  it "should not warn about unreasonably long time spans for others" do
    @event = assign(:event, FactoryGirl.create(:event, :with_unreasonably_long_range))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :coach))
    render
    expect(rendered).to_not have_text(I18n.t 'events.notices.unreasonable_timespan')
  end

  it "should not display accept-all-button for non-organizers" do
    @event = assign(:event, FactoryGirl.create(:event, :in_selection_phase_with_no_mails_sent))
    @event.max_participants = @event.application_letters.size + 1
    @event.save
    [:coach, :pupil].each do | each |
      sign_in(FactoryGirl.create(:user, role: each))
      render
      expect(rendered).to_not have_link(I18n.t('events.applicants_overview.accept_all'))
    end
  end

  it "should display accept-all-button for organizers if there are enough free places" do
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase_with_no_mails_sent))
    @event.max_participants = @event.application_letters.size + 1
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_link(I18n.t('events.applicants_overview.accept_all'))
  end

  it "should not display accept-all-button if there are not enough free places" do
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase_with_no_mails_sent))
    @event.max_participants = 1
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_link(I18n.t('events.applicants_overview.accept_all'))
  end

  it "displays material area" do
    render
    expect(rendered).to have_text(t(:title, title: @event.name, scope: 'events.material_area'))
    expect(rendered).to have_css("th", :text => t(:table_name, scope:'events.material_area'))
    expect(rendered).to have_css("th", :text => t(:table_type, scope:'events.material_area'))
    expect(rendered).to have_css("th", :text => t(:table_action, scope:'events.material_area'))
    expect(rendered).to have_button(t(:upload, scope: 'events.material_area'))
    expect(rendered).to have_button(t(:download, scope: 'events.material_area'))
  end

  it "does not display apply button when application deadline is over" do
    @event.application_deadline = Date.yesterday
    [:pupil, :coach, :organizer].each do |role|
      sign_in FactoryGirl.create(:user, role: role)
      render
      expect(rendered).to_not have_link(I18n.t("helpers.links.apply"))
    end
  end

  it "displays a button to view the application if application deadline is over for an event where the pupil has applied" do
    pupil = FactoryGirl.create(:user, role: :pupil)
    application_letter = FactoryGirl.create(:application_letter, user: pupil, event: @event)
    @event.application_deadline = Date.yesterday
    sign_in pupil
    render
    expect(rendered).to have_link(I18n.t("helpers.links.show_application"), href: check_application_letter_path(application_letter))
  end

  it "should not display radio buttons to change application statuses if the event is in application state" do
    @event = FactoryGirl.create(:event, :in_application_phase)
    @application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user, role: :pupil), event: @event)
    @event.application_letters.push(@application_letter)
    assign(:has_free_places, @event.compute_free_places > 0)
    [:pupil, :coach, :organizer].each do |role|
      sign_in FactoryGirl.create(:user, role: role)
      render
      ApplicationLetter.statuses.keys.each do |status|
        expect(rendered).to_not have_link(I18n.t("application_status.#{status}"))
      end
    end
  end

  it "displays correct buttons in draft phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_draft_phase))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:show_participants, scope: 'events.participants'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays correct buttons in application phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_application_phase))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:show_participants, scope: 'events.participants'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "does not display the disabled send email buttons in application phase (even when there are unclassified applications)" do
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_application_phase))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays correct buttons in selection phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_selection_phase_with_no_mails_sent))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to have_button(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to have_button(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:show_participants, scope: 'events.participants'))
  end

  it "does not display send acceptances button after acceptances have been sent in selection phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_selection_phase_with_acceptances_sent))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'))
  end

  it "does not display send acceptances button after acceptances have been sent in selection phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_selection_phase_with_rejections_sent))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'))
  end

  it "displays the disabled send email buttons in selection phase (when there are unclassified applications)" do
    @event = assign(:event, FactoryGirl.create(:event, :with_diverse_open_applications, :in_selection_phase_with_no_mails_sent))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays the disabled send email buttons in selection phase (when there are too many accepted applications)" do
    @event = assign(:event, FactoryGirl.create(:event_with_accepted_applications, :in_selection_phase_with_no_mails_sent, max_participants: 1))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays correct buttons in execution phase" do
    @event = assign(:event, FactoryGirl.create(:event, :in_execution_phase))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to have_link(t(:show_participants, scope: 'events.participants'))
    expect(rendered).to_not have_button(t(:sending_acceptances, scope: 'events.applicants_overview'), disabled: true)
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'), disabled: true)
  end

  it "displays correct buttons in execution phase when there are alternatives accepted with no status notification sent" do
    @event = assign(:event, FactoryGirl.create(:event_in_execution_with_applications_in_various_states, :with_no_status_notification_sent, accepted_application_letters_count: 1))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to_not have_link(t(:print_all, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_link(t(:accept_all, scope: 'events.applicants_overview'))
    expect(rendered).to have_button(t(:sending_acceptances, scope: 'events.applicants_overview'))
    expect(rendered).to_not have_button(t(:sending_rejections, scope: 'events.applicants_overview'))
    expect(rendered).to have_link(t(:show_participants, scope: 'events.participants'))
  end

  it "should display particiants button when email were already sent as organizer" do
    @event = assign(:event, FactoryGirl.create(:event, :in_execution_phase))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).to have_link(t('events.participants.show_participants'))
  end

  it "should not display particiants button when emails have not been sent as organizer" do
    @event = assign(:event, FactoryGirl.create(:event, :in_selection_phase_with_no_mails_sent))
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer))
    render
    expect(rendered).not_to have_link(t('events.participants.show_participants'))
  end

  it "renders a cancel button but no envelope glypicon for accepted applications with status notification sent in execution phase" do
    @event = assign(:event, FactoryGirl.create(:event_in_execution_with_applications_in_various_states, :with_status_notification_sent, accepted_application_letters_count: 1))
    @application_letters = @event.application_letters
    @application_letter = @event.application_letters.find{|l| l.status == 'accepted'}
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer)) 
    render
    expect(rendered).to have_link(I18n.t('application_status.actions.cancel'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))  
    expect(rendered).to_not have_css('span.glyphicon-envelope')
  end

  it "renders an envelope glyphicon but no cancel button in execution phase for each accepted application with status notification sent flag not set" do
    @event = assign(:event, FactoryGirl.create(:event_in_execution_with_applications_in_various_states, :with_no_status_notification_sent, accepted_application_letters_count: 1))
    @application_letters = @event.application_letters
    @application_letter = @event.application_letters.find{|l| l.status == 'accepted'}
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer)) 
    render
    expect(rendered).to have_css('span.glyphicon-envelope', count: 1)
    expect(rendered).to_not have_link(I18n.t('application_status.actions.cancel'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))  
  end

  it "renders an accept button for alternative applications in execution phase" do
    @event = assign(:event, FactoryGirl.create(:event_in_execution_with_applications_in_various_states, alternative_application_letters_count: 1))
    @application_letters = @event.application_letters
    @application_letter = @event.application_letters.find{|l| l.status == 'alternative'}
    assign(:has_free_places, @event.compute_free_places > 0)
    sign_in(FactoryGirl.create(:user, role: :organizer)) 
    render
    expect(rendered).to have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))  
  end

  it "doesnt render an accept button for alternative applications in execution phase when there are not enough free places" do
    @event = assign(:event, FactoryGirl.create(:event_in_execution_with_applications_in_various_states, alternative_application_letters_count: 1))
    @application_letters = @event.application_letters
    @application_letter = @event.application_letters.find{|l| l.status == 'alternative'}
    assign(:has_free_places, false)
    sign_in(FactoryGirl.create(:user, role: :organizer)) 
    render
    expect(rendered).to_not have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end

  it "renders an accept button for rejected applications in execution phase when there are no alternative applications" do
    @event = assign(:event, FactoryGirl.create(:event_in_execution_with_applications_in_various_states, rejected_application_letters_count: 1, alternative_application_letters_count: 0))
    @application_letters = @event.application_letters
    @application_letter = @event.application_letters.find{|l| l.status == 'rejected'}
    assign(:has_free_places, @event.compute_free_places > 0)
    render
    expect(rendered).to have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end

  it "doesnt render an accept button for rejected applications in execution phase when there are alternative applications" do
    @event = assign(:event, FactoryGirl.create(:event_in_execution_with_applications_in_various_states,  rejected_application_letters_count: 1, alternative_application_letters_count: 2))
    @application_letters = @event.application_letters
    @application_letter = @event.application_letters.find{|l| l.status == 'rejected'}
    assign(:has_free_places, @event.compute_free_places > 0)
    render
    expect(rendered).to_not have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end

  it "doesnt render an accept button for rejected applications in execution phase when there are not enough free places" do
    @event = assign(:event, FactoryGirl.create(:event_in_execution_with_applications_in_various_states, rejected_application_letters_count: 1, alternative_application_letters_count: 0))
    @application_letters = @event.application_letters
    @application_letter = @event.application_letters.find{|l| l.status == 'rejected'}
    assign(:has_free_places, false)
    render
    expect(rendered).to_not have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end
end
