class EmailsController < ApplicationController

  def show
    authorize! :send_email, Email
    @event = Event.find(params[:event_id])

    @templates = get_templates
    @addresses = @event.email_addresses_of_type(get_status)

    @email = Email.new(hide_recipients: true, reply_to: 'workshop.portal@hpi.de', recipients: @addresses,
                       subject: '', content: '')
    render :email
  end

  def submit
    authorize! :send_email, Email
    if send?
      send_email
    elsif save_template?
      save_template
    end
  end


  private

  def send_email
    @email = Email.new(email_params)
    if @email.valid?
      Mailer.send_generic_email(@email.hide_recipients, @email.recipients, @email.reply_to, @email.subject, @email.content)

      @event = Event.find(params[:event_id])
      @event.lock_application_status

      redirect_to @event, notice: t('.sending_successful')
    else
      @event = Event.find(params[:event_id])
      @templates = get_templates

      flash.now[:alert] = t('.sending_failed')
      render :email
    end
  end

  def save_template
    @email = Email.new(email_params)

    @template = EmailTemplate.new({ status: get_status, hide_recipients: @email.hide_recipients,
                                    subject: @email.subject, content: @email.content })

    if @email.validate_attributes [:subject, :content] and @template.save
      flash.now[:success] = t('.saving_successful')
    else
      flash.now[:alert] = t('.saving_failed')
    end
    @event = Event.find(params[:event_id])
    @templates = get_templates

    render :email
  end

  def get_templates
    if params[:status]
      EmailTemplate.where(status: EmailTemplate.statuses[params[:status].to_sym]).to_a
    else
      EmailTemplate.where(status: EmailTemplate.statuses[:default]).to_a
    end
  end

  def get_status
    if params[:status]
       params[:status]
    else
      :default
    end
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
