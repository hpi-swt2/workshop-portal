# == Schema Information
#
# Table name: requests
#
#  id                     :integer          not null, primary key
#  annotations            :text
#  contact_person         :string
#  email                  :string
#  first_name             :string
#  form_of_address        :integer
#  grade                  :string
#  knowledge_level        :string
#  last_name              :string
#  notes                  :text
#  number_of_participants :integer
#  phone_number           :string
#  school_street          :string
#  school_zip_code_city   :string
#  status                 :integer          default("open")
#  time_period            :text
#  topic_of_workshop      :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Request < ActiveRecord::Base
  validates_presence_of :form_of_address, :last_name, :first_name, :phone_number, :school_street, :school_zip_code_city, :email, :topic_of_workshop
  validates :number_of_participants, numericality: { only_integer: true, greater_than: 0 }, allow_nil: :true
  validates_format_of :email, with: Devise.email_regexp

  enum form_of_address: %i(mr mrs prefer_to_omit)
  enum status: %i(open accepted declined) # per database declaration, the first value is default

  def name
    "#{first_name} #{last_name}"
  end
end
