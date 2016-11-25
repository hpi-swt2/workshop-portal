class AgreementLettersController < ApplicationController
  authorize_resource :class => false
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
        save(file)
        redirect_to profile_path(current_user.profile),
                    notice: t("agreement_letters.upload_success")
      end
    else
      render(file: File.join(Rails.root, 'public/422'), formats: [:html], status: 422, layout: false)
    end
  end

  def show
    redirect_to profile_path(current_user.profile)
  end

  private
    def save(file)
    end
end
