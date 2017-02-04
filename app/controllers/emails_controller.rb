class EmailsController < ApplicationController

  def show
    authorize! :send_email, Email
    @event = Event.find(params[:event_id])

    @templates = EmailTemplate.with_status(get_email_template_status)
    application_letter_status = get_corresponding_application_letter_status
    @addresses = @event.email_addresses_of_type_without_notification_sent(application_letter_status)

    @email = Email.new(hide_recipients: true, reply_to: Rails.configuration.reply_to_address, recipients: @addresses.join(','),
                       subject: '', content: '')

    render :email
  end

  def submit
    authorize! :send_email, Email
    if params[:send]
      send_email
    elsif params[:save]
      save_template
    end
  end


  private

  def send_email
    @email = Email.new(email_params)
    @event = Event.find(params[:event_id])
    status = get_email_template_status
    if @email.valid?
      application_letter_status = get_corresponding_application_letter_status
      if application_letter_status == :accepted
        @email.send_email_with_ical @event
      else
        @email.send_email
      end

      @event.set_status_notification_flag_for_applications_with_status(application_letter_status)
      if status == :acceptance
        @event.acceptances_have_been_sent = true
      elsif status == :rejection
        @event.rejections_have_been_sent = true
      end
      @event.save

      redirect_to @event, notice: t('.sending_successful')
    else
      @templates = EmailTemplate.with_status(status)

      flash.now[:alert] = t('.sending_failed')
      render :email
    end
  end

  def save_template
    @email = Email.new(email_params)

    @template = EmailTemplate.new({ status: get_email_template_status, hide_recipients: @email.hide_recipients,
                                    subject: @email.subject, content: @email.content })

    if @email.validates_presence_of(:subject, :content) && @template.save
      flash.now[:success] = t('.saving_successful')
    else
      flash.now[:alert] = t('.saving_failed')
    end
    @event = Event.find(params[:event_id])
    @templates = EmailTemplate.with_status(get_email_template_status)

    render :email
  end

  def get_email_template_status
    params[:status] ? params[:status].to_sym : :default
  end

  def get_corresponding_application_letter_status
    return case params[:status]
      when "acceptance" then :accepted
      when "rejection" then :rejected
      else :accepted
      end
  end

  # Only allow a trusted parameter "white list" through.
  def email_params
    params.require(:email).permit(:hide_recipients, :recipients, :reply_to, :subject, :content)
  end
end
