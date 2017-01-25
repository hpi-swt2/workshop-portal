require "rails_helper"

describe "Sending emails to applicants", type: :feature do
  before :each do
    @accepted_count = 4
    @rejected_count = 2
    @event = FactoryGirl.create(:event_with_accepted_applications,
                                accepted_application_letters_count: @accepted_count,
                                rejected_application_letters_count: @rejected_count)
  end

  scenario "logged in as Organizer I can send emails to the applicants" do
    login(:organizer)

    visit event_email_show_path(@event, status: :accepted)
    fill_in :email_subject, with: "Subject Accepted"
    fill_in :email_content, with: "Content Accepted"
    click_button I18n.t('.emails.email_form.send')

    expect(page).to have_text(I18n.t('.emails.submit.sending_successful'))

    visit event_email_show_path(@event, status: :rejected)
    fill_in :email_subject, with: "Subject Rejected"
    fill_in :email_content, with: "Content Rejected"
    click_button I18n.t('.emails.email_form.send')

    expect(page).to have_text(I18n.t('.emails.submit.sending_successful'))
  end

  scenario "logged in as Organizer after sending an Email to the applicants the event application status gets locked" do
    login(:organizer)
    @event.application_status_locked = false
    @event.save

    visit event_email_show_path(@event, status: :accepted)
    fill_in :email_subject, with: "Subject"
    fill_in :email_content, with: "Content"
    click_button I18n.t('.emails.email_form.send')

    expect(Event.find(@event.id).application_status_locked).to be(true)
  end

  scenario "logged in as Organizer I can save an email as a template" do
    login(:organizer)

    @template_subject = "Template Subject"
    @template_content = "Template Content"

    visit event_email_show_path(@event, status: :accepted)
    fill_in :email_subject, with: @template_subject
    fill_in :email_content, with: @template_content
    click_button I18n.t('.emails.email_form.save_template')

    expect(page).to have_text(I18n.t('.emails.submit.saving_successful'))
    expect(page).to have_text(@template_subject)
    expect(page).to have_text(@template_content)
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end

