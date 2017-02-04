require 'rails_helper'
require 'request_helper'

RSpec.describe "application_letters/show", type: :view do
  before(:each) do
    @application_letter = assign(:application_letter, FactoryGirl.create(:application_letter))
    @application_note = assign(:application_note, FactoryGirl.create(:application_note, application_letter: @application_letter))
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

  it "renders application's attributes" do
    render
    expect(rendered).to have_text(@application_letter.event.name)
    expect(rendered).to have_text(@application_letter.motivation)
    expect(rendered).to have_text(@application_letter.annotation)
  end

  it "renders applicant's attributes" do
    render
    expect(rendered).to have_text(@application_letter.user.profile.name)
    expect(rendered).to have_text(@application_letter.user.profile.gender)
    expect(rendered).to have_text(@application_letter.user.profile.age_at_time(@application_letter.event.start_date))
    expect(rendered).to have_text(@application_letter.user.accepted_applications_count(@application_letter.event))
    expect(rendered).to have_text(@application_letter.user.rejected_applications_count(@application_letter.event))
  end
end
