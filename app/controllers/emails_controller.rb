class EmailsController < ApplicationController

  def show
    authorize! :send_email, Email
    @event = Event.find(params[:event_id])

    @templates = EmailTemplate.with_status(get_email_template_status)
    @addresses = @event.email_addresses_of_type(get_corresponding_application_letter_status)

    @email = Email.new(hide_recipients: true, reply_to: 'workshop.portal@hpi.de', recipients: @addresses,
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

    if @email.valid?
      @email.send_email

      status = get_email_template_status
      if(status == :acceptance || status == :rejection)
        accept_pre_accepted_applicants(@email.recipients) if status == :acceptance
        @event.lock_application_status
      end

      redirect_to @event, notice: t('.sending_successful')
    else
      @templates = EmailTemplate.with_status(get_email_template_status)

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
    return :pre_accepted if params[:status] == "acceptance"
    return :rejected if params[:status] == "rejection"
    # default value
    return :accepted
  end

  # Only allow a trusted parameter "white list" through.
  def email_params
    params.require(:email).permit(:hide_recipients, :recipients, :reply_to, :subject, :content)
  end

  def accept_pre_accepted_applicants(email_addresses)
    if email_addresses.is_a? String
      email_addresses = email_addresses.split(',')
    end
    email_addresses.each do |address|
      user = User.where(email: address)
      letter = @event.application_letters.find_by(user: user)
      letter.status = ApplicationLetter.statuses[:accepted]
      letter.save!
    end
  end
end
