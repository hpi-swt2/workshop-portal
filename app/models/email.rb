class Email
  include ActiveAttr::TypecastedAttributes
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attribute :hide_recipients, :type => Boolean
  attribute :recipients, :type => String
  attribute :reply_to, :type => String
  attribute :subject, :type => String
  attribute :content, :type => String

  validates_presence_of :recipients, :reply_to, :subject, :content
  validates_inclusion_of :hide_recipients, in: [true, false]
  after_validation :convert_line_breaks

  def convert_line_breaks
    unless self.content.blank?
      self.content = self.content.gsub!(/\n/, '<br/>')
    end
  end

  def persisted?
    false
  end
end
