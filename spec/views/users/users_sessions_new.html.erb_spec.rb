require 'rails_helper'


RSpec.describe "users/sessions/new", type: :view do
  before(:each) do
    without_partial_double_verification do
      allow(view).to receive(:resource_class).and_return(devise_mapping.to)
    end
  end

  it "has the correct fields" do
    render()
    expect(rendered).to have_text(I18n.t('.start_page.register_now', :default => "Register"))
    expect(rendered).to have_text(I18n.t('.users.sessions.new.sign_in', :default => "Sign in"))
    expect(rendered).to have_text(I18n.t('devise.shared.links.sign_in_with_provider', :provider => 'HPI OpenID'))
  end
end