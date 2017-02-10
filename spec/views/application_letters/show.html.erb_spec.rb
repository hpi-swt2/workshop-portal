require 'rails_helper'
require 'request_helper'

RSpec.describe "application_letters/show", type: :view do
  before(:each) do
    @application_letter = assign(:application_letter, FactoryGirl.create(:application_letter))
    @application_note = assign(:application_note, FactoryGirl.create(:application_note, application_letter: @application_letter))

    assign(:has_free_places, @application_letter.event.compute_free_places > 0)
    profile = FactoryGirl.create(:profile, user: (FactoryGirl.create :user, role: :organizer))
    sign_in profile.user
  end

  it "renders radio buttons for accept reject pending and alternative, but not canceled in selection phase" do
    @application_letter.event = FactoryGirl.create(:event, :in_selection_phase_with_no_mails_sent)
    render
    expect(rendered).to have_css("label", text: I18n.t('application_status.accepted'))
    expect(rendered).to have_css("label", text: I18n.t('application_status.rejected'))
    expect(rendered).to have_css("label", text: I18n.t('application_status.pending'))
    expect(rendered).to have_css("label", text: I18n.t('application_status.alternative'))
    expect(rendered).to_not have_css("label", text: I18n.t('application_status.canceled'))
  end

  it "renders application's attributes, including custom application fields" do
    render
    expect(rendered).to have_text(@application_letter.event.name)
    expect(rendered).to have_text(@application_letter.motivation)
    expect(rendered).to have_text(@application_letter.annotation)
    @application_letter.event.custom_application_fields.each do |field_name|
      expect(rendered).to have_text(field_name)
    end
    @application_letter.custom_application_fields.each do |field_value|
      expect(rendered).to have_text(field_value)
    end
  end

  it "renders applicant's attributes" do
    render
    expect(rendered).to have_text(@application_letter.user.profile.name)
    expect(rendered).to have_text(@application_letter.user.profile.gender)
    expect(rendered).to have_text(@application_letter.user.profile.age_at_time(@application_letter.event.start_date))
    expect(rendered).to have_text(@application_letter.user.accepted_applications_count(@application_letter.event))
    expect(rendered).to have_text(@application_letter.user.rejected_applications_count(@application_letter.event))
  end

  it "renders a cancel button but no envelope glyphicon for accepted applications with status notification sent in execution phase" do
    @application_letter.status = :accepted
    @application_letter.status_notification_sent = true
    @application_letter.event = FactoryGirl.create(:event, :in_execution_phase)
    assign(:has_free_places, @application_letter.event.compute_free_places > 0)
    render
    expect(rendered).to have_link(I18n.t('application_status.actions.cancel'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))
    expect(rendered).to_not have_css('span.glyphicon-envelope')
  end

 it "renders an envelope glyphicon but no cancel button in execution phase for an accepted application with status notification sent flag not set" do
    @application_letter.status = :accepted
    @application_letter.status_notification_sent = false
    @application_letter.event = FactoryGirl.create(:event, :in_execution_phase)
    assign(:has_free_places, @application_letter.event.compute_free_places > 0)
    render
    sign_in(FactoryGirl.create(:user, role: :organizer)) 
    render
    expect(rendered).to have_css('span.glyphicon-envelope')
    expect(rendered).to_not have_link(I18n.t('application_status.actions.cancel'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :canceled))
  end

 %i[rejected alternative canceled].each do |status|
   it "doesnt render an envelope glyphicon in execution phase for each #{status} application with status notification sent flag not set" do
      @application_letter.status = status
      @application_letter.status_notification_sent = false
      @application_letter.event = FactoryGirl.create(:event, :in_execution_phase)
      assign(:has_free_places, @application_letter.event.compute_free_places > 0)
      render
      sign_in(FactoryGirl.create(:user, role: :organizer)) 
      render
      expect(rendered).to_not have_css('span.glyphicon-envelope')
    end
  end

  it "renders an accept button for alternative applications in execution phase" do
    @application_letter.status = :alternative
    @application_letter.event = FactoryGirl.create(:event, :in_execution_phase)
    assign(:has_free_places, @application_letter.event.compute_free_places > 0)
    render
    expect(rendered).to have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))  
  end

  it "doesnt render an accept button for alternative applications in execution phase when there are not enough free places" do
    @application_letter.status = :alternative
    @application_letter.event = FactoryGirl.create(:event, :in_execution_phase)
    assign(:has_free_places, false)
    render
    expect(rendered).not_to have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))  
  end

  it "renders an accept button for rejected applications in execution phase when there are no alternative applications" do
    @application_letter.status = :rejected
    @application_letter.event = FactoryGirl.create(:event, :in_execution_phase)
    assign(:has_free_places, @application_letter.event.compute_free_places > 0)
    render
    expect(rendered).to have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end

  it "doesnt render an accept button for rejected applications in execution phase when there are alternative applications" do
    @application_letter.status = :rejected
    @application_letter.event = FactoryGirl.create(:event, :in_execution_phase)
    @application_letter.event.application_letters.push(FactoryGirl.create(:application_letter_alternative))
    assign(:has_free_places, @application_letter.event.compute_free_places > 0)
    render
    expect(rendered).to_not have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end

  it "doesnt render an accept button for rejected applications in execution phase when there are not enough free places" do
    @application_letter.status = :rejected
    @application_letter.event = FactoryGirl.create(:event, :in_execution_phase)
    assign(:has_free_places, false)
    render
    expect(rendered).to_not have_link(I18n.t('application_status.actions.accept'), href: update_application_letter_status_path(@application_letter, 'application_letter[status]': :accepted))
  end
end
