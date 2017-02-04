# == Model Information
#
#  hide_recipients        :boolean          not null
#  recipients             :string           not null
#  reply_to               :string           not null
#  subject                :string           not null
#  content                :string           not null
#
class Email
  include ActiveAttr::TypecastedAttributes
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attribute :hide_recipients, :type => Boolean
  attribute :recipients, :type => String
  attribute :reply_to, :type => String
  attribute :subject, :type => String
  attribute :content, :type => String

  validates_presence_of :recipients, :reply_to, :subject, :content
  validates_inclusion_of :hide_recipients, in: [true, false]

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def send_email_with_ical(event)
    send_email([get_ical_attachment(event)])
  end

  def send_email(attachments = [])
    Mailer.send_generic_email(hide_recipients, recipients, reply_to, subject, content, attachments)
  end

  def persisted?
    false
  end

  private

  def get_ical_attachment(event)
    cal = Icalendar::Calendar.new
    for date_range in event.date_ranges do
      cal.event do |e|
        e.dtstart     = date_range.start_date
        e.dtend       = date_range.end_date
        e.summary     = event.name
        e.description = event.description
        e.url         = Rails.application.routes.url_helpers.event_path(event)
      end
    end

    {name: (I18n.t 'emails.ical_attachment'), content: cal.to_ical}
  end
end
