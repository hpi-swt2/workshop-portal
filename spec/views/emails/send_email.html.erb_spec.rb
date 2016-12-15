require 'rails_helper'

RSpec.describe "emails/email_form", type: :view do
  before(:each) do
    @email = assign(:email, FactoryGirl.build(:email))
    sign_in(FactoryGirl.create(:user, role: :admin))
    render :partial => "emails/email_form"
  end

  it("renders required email fields") do
    expect(rendered).to have_field(I18n.t'emails.email_form.show_recipients')
    expect(rendered).to have_field(I18n.t'emails.email_form.hide_recipients')

    expect(rendered).to have_field('email_recipients')
    expect(rendered).to have_field('email_reply_to')
    expect(rendered).to have_field('email_subject')
    expect(rendered).to have_field('email_content')
  end

  it "renders email send button" do
    expect(rendered).to have_button(I18n.t('emails.email_form.send'))
  end

  it "fills recipients_fills with set recipients" do
    expect(rendered).to have_field('email_recipients', with: @email.recipients)
  end
end
