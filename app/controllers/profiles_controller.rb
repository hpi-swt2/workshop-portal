class ProfilesController < ApplicationController
  load_and_authorize_resource

  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles/1
  def show
  end

  # GET /profiles/new
  def new
    existing_profile = Profile.find_by(user: current_user.id)
    return redirect_to existing_profile if existing_profile.present?

    @profile = Profile.new
    flash.keep(:event_id)
  end

  # GET /profiles/1/edit
  def edit
    flash.keep(:application_id)
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id

    existing_profile = Profile.find_by(user: current_user.id)
    return redirect_to existing_profile if existing_profile.present?

    if @profile.save
      if flash[:event_id]
        redirect_to new_application_letter_path(:event_id => flash[:event_id]), notice: I18n.t('profiles.successful_creation')
      else
        redirect_to edit_user_registration_path, notice: I18n.t('profiles.successful_creation')
      end
    else
      flash.keep(:event_id)
      render :new
    end
  end

  # PATCH/PUT /profiles/1
  def update
    if @profile.update(profile_params)
      if flash[:application_id]
        redirect_to check_application_letter_path(flash[:application_id]), notice: I18n.t('profiles.successful_update')
      else
        redirect_to @profile, notice: I18n.t('profiles.successful_update')
      end
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def profile_params
      params.require(:profile).permit(Profile.allowed_params)
    end
end
