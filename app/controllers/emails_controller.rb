class EmailsController < ApplicationController
  def send_email
    @email = Email.new(email_params)
    Mailer.send_generic_email(@email.hide_recipients, @email.recipients, @email.reply_to, @email.subject, @email.content)
    redirect_to :events, notice: t('.sending_successful')
  end

  private

  # Only allow a trusted parameter "white list" through.
  def email_params
    params.require(:email).permit(:hide_recipients, :recipients, :reply_to, :subject, :content)
  end
end
