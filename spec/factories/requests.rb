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

FactoryGirl.define do
  factory :request do
    form_of_address :mrs
    first_name "Martina"
    last_name "Mustermann"
    phone_number "0123456789"
    school_street "Musterstraße 1"
    school_zip_code_city "12345 Musterstadt"
    email "mustermann@example.de"
    topic_of_workshop "Hardware-Entwicklung mit einem CAD-System"
    number_of_participants 12
    grade "8. Klasse"
    knowledge_level "Haben gerade mit Java-Kara angefangen"
    status :open
    annotations "Notes about this workshop"
    time_period "Zwischen Ende Januar und Mitte März"
  end
end
