require "rails_helper"

# https://www.relishapp.com/rspec/rspec-rails/v/3-5/docs/feature-specs/feature-spec
RSpec.feature "Account creation vis HPI OpenID", :type => :feature do
  before(:each) do
    user = 'christian.flach'
    @email = user + '@student.hpi.de'
    @uid = 'https://openid.hpi.uni-potsdam.de/user/' + user
    @provider = 'hpiopenid'
    OmniAuth.config.test_mode = true
    # By default Omniauth will raise an exception in development and test for invalid credentials.
    # If you'd like to be redirected to the /auth/failure endpoint in those environments include this code:
    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
    OmniAuth.config.mock_auth[:hpiopenid] = OmniAuth::AuthHash.new({
                                                                     :provider => @provider,
                                                                     :uid => @uid,
                                                                     :info => {
                                                                         :email => @email
                                                                     }
                                                                 })
  end

  scenario "User creates an account via HPI OpenID" do
    visit new_user_registration_path
    click_link I18n.t('devise.shared.links.sign_in_with_provider', :provider => 'HPI OpenID')

    expect(page).to have_css(".alert-success")

    user = User.find_by_email(@email)
    expect(user.role).to eq(:pupil.to_s)
    expect(user.provider).to eq(@provider)
    expect(user.uid).to eq(@uid)
  end

  scenario "User logs in via HPI OpenID" do
    FactoryGirl.create(:user, email: @email, provider: @provider, uid: @uid)

    visit new_user_registration_path
    click_link I18n.t('devise.shared.links.sign_in_with_provider', :provider => 'HPI OpenID')

    expect(page).to have_css(".alert-success")
  end
end
