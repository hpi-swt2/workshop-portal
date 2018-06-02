# == Schema Information
#
# Table name: email_templates
#
#  id              :integer          not null, primary key
#  content         :text
#  hide_recipients :boolean
#  status          :integer
#  subject         :string
#

class EmailTemplate < ActiveRecord::Base
  enum status: { default: 0, acceptance: 1, rejection: 2 }

  validates_inclusion_of :status, in: statuses.keys
  validates_inclusion_of :hide_recipients, in: [true, false]
  validates_presence_of :subject, :content

  scope :with_status, ->(status) { where(status: statuses[status]).to_a }
end
