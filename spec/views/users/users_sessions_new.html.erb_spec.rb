require 'rails_helper'


RSpec.describe "users/sessions/new", type: :view do 
  
  it "has the correct fields" do
  	render 
    expect(rendered).to have_text(I18n.t('.start_page.register_now', :default => "Register"))
    expect(rendered).to have_text(I18n.t('.users.sessions.new.sign_in', :default => "Sign in"))
    
  end
end