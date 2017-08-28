class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :hpiopenid

  def hpiopenid
    if request.env['omniauth.auth'].info.email.to_s.empty?
      return redirect_to user_session_path, alert: I18n.t('users.openid.missing_email')
    end
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'HPI OpenID') if is_navigational_format?
    end
  end
end
