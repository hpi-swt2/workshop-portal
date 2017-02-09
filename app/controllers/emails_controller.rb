class EmailsController < ApplicationController

  def show
    authorize! :send_email, Email
    @event = Event.find(params[:id])

    @templates = EmailTemplate.with_status(get_status)
    @addresses = @event.email_addresses_of_type_without_notification_sent(get_status)

    if (get_status == :rejected) && (@event.has_participants_without_status_notification?(:alternative))
      @addresses.append(@event.email_addresses_of_type_without_notification_sent(:alternative))
    end

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
    @event = Event.find(params[:id])
    @templates = EmailTemplate.with_status(get_status)

    if @email.valid?
      @attachments = []
      if get_status == :accepted
        @attachments.push(@event.get_ical_attachment)
      end

      @generic = generic?
      @force_generic = force_generic?

      if !@email.containsPersonalizationTags? || generic? or force_generic?
        @email.send_generic_email(@attachments)
      else
        if @email.personalizable?
          @email.send_personalized_email(@attachments)
        else
          flash.now[:warning] = t('emails.submit.personalization_warning')
          params[:force_generic] = true
          render :email
          return
        end
      end

      update_event(@event)

      redirect_to @event, notice: t('emails.submit.sending_successful')
    else
      flash.now[:alert] = t('emails.submit.sending_failed')
      render :email
    end
  end

  def save_template
    @email = Email.new(email_params)

    @template = EmailTemplate.new({ status: get_status, hide_recipients: @email.hide_recipients,
                                    subject: @email.subject, content: @email.content })

    if @email.validates_presence_of(:subject, :content) && @template.save
      flash.now[:success] = t('emails.submit.saving_successful')
    else
      flash.now[:alert] = t('emails.submit.saving_failed')
    end
    @event = Event.find(params[:id])
    @templates = EmailTemplate.with_status(get_status)
    render :email
  end

  def update_event(event)
    if get_status == :accepted
      event.set_status_notification_flag_for_applications_with_status(get_status)
      event.acceptances_have_been_sent = true
      if not (event.has_participants_without_status_notification?(:rejected) || @event.has_participants_without_status_notification?(:alternative))
        event.rejections_have_been_sent = true
      end
    elsif get_status == :rejected
      event.rejections_have_been_sent = true
      event.set_status_notification_flag_for_applications_with_status(get_status)
      event.set_status_notification_flag_for_applications_with_status(:alternative)
    end
    event.save
  end

  def get_status
    params[:status] ? params[:status].to_sym : :default
  end

  def generic?
    # personalization depends on the existens of tags unless specificly turned off
    params[:generic] ? (params[:generic] == 'true' ? true : false) : false
  end

  def force_generic?
    params[:force_generic] ? true : false
  end

  # Only allow a trusted parameter "white list" through.
  def email_params
    params.require(:email).permit(:hide_recipients, :recipients, :reply_to, :subject, :content)
  end
end
