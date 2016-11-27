class AgreementLettersController < ApplicationController
  authorize_resource

  def create
    @event_id = params[:event_id]
    @file = params[:letter_upload]
    if params_valid?
      if @file.content_type != AgreementLetter::ALLOWED_MIMETYPE
        redirect_to profile_path(current_user.profile),
                    alert: t("agreement_letters.wrong_filetype")
      elsif @file.size > AgreementLetter::MAX_SIZE
        redirect_to profile_path(current_user.profile),
                    alert: t("agreement_letters.file_too_big")
      else
        if save_file
          redirect_to profile_path(current_user.profile),
                      notice: t("agreement_letters.upload_success")
        else
          redirect_to profile_path(current_user.profile),
                      alert: t("agreement_letters.upload_failed")
        end
      end
    else
      render(file: File.join(Rails.root, 'public/422'), formats: [:html], status: 422, layout: false)
    end
  end

  private
    def params_valid?
      Event.exists?(@event_id) and
        @file.respond_to?(:open) and
        @file.respond_to?(:content_type) and
        @file.respond_to?(:size)
    end

    def save_file
      @agreement_letter = AgreementLetter.where(user: current_user, event_id: @event_id).take
      if @agreement_letter.nil?
        @agreement_letter = AgreementLetter.new
        @agreement_letter.user = current_user
        @agreement_letter.event_id = @event_id
        @agreement_letter.path = Rails.root.join('storage/agreement_letters', @agreement_letter.filename).to_s
        File.open(@agreement_letter.path, 'wb') { |f| f.write(@file.read) }
        @agreement_letter.save
      else
        File.open(@agreement_letter.path, 'wb') { |f| f.write(@file.read) }
        @agreement_letter.touch
      end
    end
end
