# == Schema Information
#
# Table name: email_templates
#
#  id                     :integer          not null, primary key
#  status                 :integer          not null
#  hide_recipients        :boolean          not null
#  subject                :string           not null
#  content                :string           nol null
#
class EmailTemplate < ActiveRecord::Base

  enum status: { accepted: 1, rejected: 0 }
  validates_inclusion_of :status, in: statuses.keys
  validates_inclusion_of :hide_recipients, in: [ true, false ]
  validates_presence_of :subject, :content
end
