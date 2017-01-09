class EmailsController < ApplicationController

  def show
    @event = Event.find(params[:event_id])

    if params[:status]
      @status = params[:status].to_sym
      @addresses = @event.email_addresses_of_type(@status)
      @templates = EmailTemplate.where(status: EmailTemplate.statuses[@status]).to_a
    else
      @addresses = ''
    end

    @email = Email.new(hide_recipients: false, reply_to: 'workshop.portal@hpi.de', recipients: @addresses,
                       subject: '', content: '')
    render :email
  end

  def submit
    @email = Email.new(params[:email])
    if send?
      send_email(@email)
    elsif save_template?
      save_template(@email)
    end
  end


  private

  def send_email(email)
    if email.valid?
      Mailer.send_generic_email(email.hide_recipients, email.recipients, email.reply_to, email.subject, email.content)
      @event = Event.find(params[:event_id])
      @event.lock_application_status
      redirect_to @event, notice: t('.sending_successful')
    else
      @event = Event.find(params[:event_id])
      flash.now[:alert] = t('.sending_failed')
      show
    end
  end

  def save_template(email)
    @template_params = { status: params[:status],
                         hide_recipients: email.hide_recipients,
                         subject: email.subject,
                         content: email.content
    }
    @template = EmailTemplate.new(@template_params)

    if @template.save
      flash.now[:success] = t('.saving_successful')
    else
      flash.now[:alert] = t('.saving_failed')
    end

    show
  end

  def send?
    params[:commit] == t('emails.email_form.send')
  end

  def save_template?
    params[:commit] == t('emails.email_form.save_template')
  end


  # Only allow a trusted parameter "white list" through.
  def email_params
    params.require(:email).permit(:hide_recipients, :recipients, :reply_to, :subject, :content)
  end
end
