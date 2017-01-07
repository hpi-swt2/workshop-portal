# == Schema Information
#
#  hide_recipients        :boolean          not null
#  recipients             :string           not null
#  reply_to               :string           not null
#  subject                :string           not null
#  content                :string           nol null
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

  def persisted?
    false
  end
end
