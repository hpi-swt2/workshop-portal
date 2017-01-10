require 'rails_helper'

RSpec.describe "emails/email_form", type: :view do
  before(:each) do
    sign_in(FactoryGirl.create(:user, role: :admin))

    @event = FactoryGirl.create(:event)
    @email = assign(:email, FactoryGirl.build(:email))

    controller.request.path_parameters[:event_id] = @event.id
    render partial: "emails/email_form"
  end

  it("renders required email fields") do
    expect(rendered).to have_field(I18n.t'emails.email_form.show_recipients')
    expect(rendered).to have_field(I18n.t'emails.email_form.hide_recipients')

    expect(rendered).to have_field('email_recipients')
    expect(rendered).to have_field('email_reply_to')
    expect(rendered).to have_field('email_subject')
    expect(rendered).to have_field('email_content')
  end

  it "renders email submit buttons" do
    expect(rendered).to have_button(I18n.t('emails.email_form.send'))
    expect(rendered).to have_button(I18n.t('emails.email_form.save_template'))
  end

  it "renders copy recipients button" do
    expect(rendered).to have_button(I18n.t('emails.email_form.copy'))
  end

  it "fills recipients_fills with set recipients" do
    expect(rendered).to have_field('email_reply_to', with: @email.reply_to)
    expect(rendered).to have_field('email_recipients', with: @email.recipients)
  end
end
