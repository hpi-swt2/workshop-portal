class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    unless params.fetch(:user, false) and params[:user].fetch(:profile, false)
      return super
    end
    @user = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    @user.profile.update(params.require(:user).require(:profile).permit(Profile.allowed_params))

    if @user.profile.save
      redirect_to edit_user_registration_path, notice: I18n.t('profiles.successful_update')
    else
      render :edit
    end
  end


  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    new_profile_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
