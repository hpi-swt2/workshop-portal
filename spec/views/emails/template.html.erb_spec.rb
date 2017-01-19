require 'rails_helper'

RSpec.describe "emails/template", type: :view do
  before(:each) do
    sign_in(FactoryGirl.create(:user, role: :admin))

    @template = FactoryGirl.create(:email_template)
    @templates = Array(@template)
    render :partial => "emails/templates"
  end

  it "renders template headline" do
    expect(rendered).to have_text(I18n.t('.emails.templates.templates'))
  end

  it "renders template information" do
    expect(rendered).to have_text(@template.subject)
    expect(rendered).to have_text(@template.content)
  end
end
