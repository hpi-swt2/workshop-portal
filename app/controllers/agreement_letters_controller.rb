class AgreementLettersController < ApplicationController
  def upload
    redirect_to profile_path(1)
    #redirect_to profile_path(current_user.profile)
  end

  def download
    redirect_to profile_path(1)
    #redirect_to profile_path(current_user.profile)
  end
end
