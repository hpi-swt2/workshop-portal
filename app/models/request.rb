# == Schema Information
#
# Table name: requests
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Request < ActiveRecord::Base
  
  validates_presence_of :form_of_address, :last_name, :first_name, :phone_number, :address, :email, :topic_of_workshop
  validates :number_of_participants, numericality: { only_integer: true, greater_than: 0 }
  validates_format_of :email, :with => Devise::email_regexp
  
  enum form_of_address: [:mr, :mrs, :prefer_to_omit]
end
