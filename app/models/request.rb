# == Schema Information
#
# Table name: requests
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  form_of_address        :integer
#  first_name             :string
#  last_name              :string
#  phone_number           :string
#  street                 :string
#  email                  :string
#  topic_of_workshop      :text
#  time_period            :text
#  number_of_participants :integer
#  knowledge_level        :string
#  annotations            :text
#  status                 :integer          default(0)
#  zip_code_city          :string
#  contact_person         :string
#  notes                  :text
#

class Request < ActiveRecord::Base
  
  validates_presence_of :form_of_address, :last_name, :first_name, :phone_number, :street, :zip_code_city, :email, :topic_of_workshop
  validates :number_of_participants, numericality: { only_integer: true, greater_than: 0 }, allow_nil: :true
  validates_format_of :email, :with => Devise::email_regexp

  enum form_of_address: [:mr, :mrs, :prefer_to_omit]
  enum status: [:open, :accepted, :declined]  # per database declaration, the first value is default

  def name
    "#{first_name} #{last_name}"
  end
end
