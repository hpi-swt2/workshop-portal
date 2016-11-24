class AgreementLettersController < ApplicationController
  authorize_resource :class => false

  def upload
    redirect_to profile_path(current_user.profile)
  end

  def download
    redirect_to profile_path(current_user.profile)
  end
end
