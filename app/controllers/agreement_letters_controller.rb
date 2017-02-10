class AgreementLettersController < ApplicationController
  authorize_resource

  def create
    event_id = params[:event_id]
    @agreement_letter = AgreementLetter.where(user: current_user, event_id: event_id).take
    if @agreement_letter.nil?
      @agreement_letter = AgreementLetter.new
      @agreement_letter.user = current_user
      @agreement_letter.event_id = event_id
      @agreement_letter.set_path
    end
    file = params[:letter_upload]
    application_letter = ApplicationLetter.where(user: current_user, event_id: event_id).first

    if @agreement_letter.save && @agreement_letter.save_file(file)
      redirect_to check_application_letter_path(application_letter),
                  notice: t("agreement_letters.upload_success")
    else
      redirect_to check_application_letter_path(application_letter),
                  alert: @agreement_letter.errors.full_messages
    end
  end
end
