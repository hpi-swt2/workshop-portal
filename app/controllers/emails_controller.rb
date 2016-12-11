class EmailsController < ApplicationController
  def new
    @email = Email.new
  end

  def send_email
    @email = Email.new(email_params)
    PortalMailer.generic_email(@email.hide_recipients, @email.recipients, @email.reply_to, @email.subject, @email.content)
    render '_email_form'
  end

  private

  # Only allow a trusted parameter "white list" through.
  def email_params
    params.require(:email).permit(:hide_recipients, :recipients, :reply_to, :subject, :content)
  end
end
