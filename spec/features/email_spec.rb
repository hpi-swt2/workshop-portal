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

    visit event_email_show_path(@event, status: :acceptance)
    fill_in :email_subject, with: "Subject Accepted"
    fill_in :email_content, with: "Content Accepted"
    click_button I18n.t('.emails.email_form.send')

    expect(page).to have_text(I18n.t('.emails.submit.sending_successful'))

    visit event_email_show_path(@event, status: :rejection)
    fill_in :email_subject, with: "Subject Rejected"
    fill_in :email_content, with: "Content Rejected"
    click_button I18n.t('.emails.email_form.send')

    expect(page).to have_text(I18n.t('.emails.submit.sending_successful'))
  end

  scenario "logged in as Organizer after sending an acceptance Email to the applicants the event application status for sending acceptances gets locked" do
    login(:organizer)
    @event.acceptances_have_been_sent = false
    @event.save

    visit event_email_show_path(@event, status: :acceptance)
    fill_in :email_subject, with: "Subject"
    fill_in :email_content, with: "Content"
    click_button I18n.t('.emails.email_form.send')

    expect(Event.find(@event.id).acceptances_have_been_sent).to be(true)
  end

  scenario "logged in as Organizer after sending an rejection Email to the applicants the event application status for sending rejections gets locked" do
    login(:organizer)
    @event.rejections_have_been_sent = false
    @event.save

    visit event_email_show_path(@event, status: :rejection)
    fill_in :email_subject, with: "Subject"
    fill_in :email_content, with: "Content"
    click_button I18n.t('.emails.email_form.send')

    expect(Event.find(@event.id).rejections_have_been_sent).to be(true)
  end

  scenario "logged in as Organizer I can save an email as a template" do
    login(:organizer)

    @template_subject = "Template Subject"
    @template_content = "Template Content"

    visit event_email_show_path(@event, status: :acceptance)
    fill_in :email_subject, with: @template_subject
    fill_in :email_content, with: @template_content
    click_button I18n.t('.emails.email_form.save_template')

    expect(page).to have_text(I18n.t('.emails.submit.saving_successful'))
    expect(page).to have_text(@template_subject)
    expect(page).to have_text(@template_content)
  end

  scenario "logged in as Organizer I can load an email template", js: true do
    login(:organizer)
    @template = FactoryGirl.create(:email_template, :acceptance)

    visit event_email_show_path(@event, status: :acceptance)
    first('.email-template').click


    expect(find('#email_hide_recipients_true', visible: false).checked?).to eq(@template.hide_recipients)
    expect(find('#email_hide_recipients_false', visible: false).checked?).to eq(!@template.hide_recipients)
    expect(page.find('#email_subject').value).to eq(@template.subject)
    expect(page.find('#email_content').value).to eq(@template.content)
  end


  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end

