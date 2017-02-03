require "rails_helper"

# Pleas note:
# Registration is handled by the Devise gem - no need to test that!
# However, some custom additions need to be tested.
describe "Registration", type: :feature do
  it "redirect me to the profile creation page after registration" do
    visit new_user_session_path

    # Create new account
    password = "123456"
    fill_in "sign_up_email", with: "walls@arenotgreat.com"
    fill_in "sign_up_password", with: password
    fill_in "sign_up_password_confirmation", with: password
    find('#sign_up_submit').click

    page.assert_current_path new_profile_path
  end
end

