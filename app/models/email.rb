class Email
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :hide_recipients, :recipients, :reply_to, :subject, :content

  validates_presence_of :hide_recipients, :recipients, :reply_to, :subject, :content

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
