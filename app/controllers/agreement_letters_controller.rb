class AgreementLettersController < ApplicationController
  load_and_authorize_resource
  MAX_SIZE = 300_000
  ALLOWED_MIMETYPE = "application/pdf"

  def create
    file = params[:letter_upload]
    if file.respond_to?(:open) and
       file.respond_to?(:content_type) and
       file.respond_to?(:size)
      if file.content_type != ALLOWED_MIMETYPE
        redirect_to profile_path(current_user.profile),
                    alert: t("agreement_letters.wrong_filetype")
      elsif file.size > MAX_SIZE
        redirect_to profile_path(current_user.profile),
                    alert: t("agreement_letters.file_too_big")
      else
        if save(file)
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

  def show
    #send_file @agreement_letter.path, type: @agreement_letter.content_type, disposition: 'inline'
    redirect_to profile_path(current_user.profile)
  end

  private
    def save(file)
      @agreement_letter.user = current_user
      FactoryGirl.create(:event).save
      @agreement_letter.event = Event.find(1) #TODO
      path = Rails.root.join('storage/agreement_letters', @agreement_letter.filename).to_s
      File.open(path, 'wb') { |f| f.write(file.read) }
      @agreement_letter.path = path
      @agreement_letter.save
    end
end
