require 'rails_helper'

RSpec.describe "profiles/_upload_form", type: :view do
  it "renders the upload form" do
    event = FactoryGirl.create(:event)
    agreement_letter = nil
    render('upload_form', event_id: event.id, agreement_letter: agreement_letter)
    expect(rendered).to have_selector("input[type=file]")
    expect(rendered).to have_button("upload_btn_#{event.id}")
  end

  it "shows upload date if agreement letter was already uploaded" do
    event = FactoryGirl.create(:event)
    agreement_letter = FactoryGirl.create(:agreement_letter)
    render('upload_form', event_id: event.id, agreement_letter: agreement_letter)
    expect(rendered).to have_text(t("agreement_letters.already_uploaded", timestamp: l(agreement_letter.updated_at)))
  end

  it "shows no date if no agreement letter was already uploaded" do
    event = FactoryGirl.create(:event)
    agreement_letter = nil
    render('upload_form', event_id: event.id, agreement_letter: agreement_letter)
    expect(rendered).not_to have_text(t("agreement_letters.already_uploaded", timestamp: nil))
  end
end

