require 'rails_helper'

RSpec.describe "emails/template", type: :view do
  before(:each) do
    sign_in(FactoryGirl.create(:user, role: :admin))

    @template = FactoryGirl.create(:email_template)
    @templates = Array(@template)
    render :partial => "emails/template"
  end

  it("renders template information") do
    expect(rendered).to have_text(@template.subject)
    expect(rendered).to have_text(@template.content)
  end
end
