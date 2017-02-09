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

  def send_generic_email(attachments = [])
    Mailer.send_generic_email(hide_recipients, recipients, reply_to, subject, content, attachments)
  end

  def send_personalized_email(attachments = [])
    users = recipients.split(',').map { | email | User.find_by(email: email) }

    users.each do | user |
      @subject = subject.clone
      @content = content.clone
      Rails.configuration.personalization_replacement.each do | key, value |
        @content.gsub! key, user.profile.send(value)
        @subject.gsub! key, user.profile.send(value)
      end
      Mailer.send_generic_email(true, user.email, reply_to, @subject, @content, attachments)
    end
  end

  def containsPersonalizationTags?
    @replacement = Rails.configuration.personalization_replacement
    @replacement.keys.any? { | key | subject.include?(key) || content.include?(key) }
  end

  def personalizable?
    # Check if a user exists for all given email addresses
    recipients.split(',').all? { | email | User.find_by(email: email).present? }
  end

  def persisted?
    false
  end
end
