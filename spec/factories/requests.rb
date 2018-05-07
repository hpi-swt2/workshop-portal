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
#  school_street          :string
#  email                  :string
#  topic_of_workshop      :text
#  time_period            :text
#  number_of_participants :integer
#  knowledge_level        :string
#  annotations            :text
#  status                 :integer          default("open")
#  school_zip_code_city   :string
#  contact_person         :string
#  notes                  :text
#  grade                  :string
#  study_info             :boolean
#  campus_tour            :boolean
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
    campus_tour false
    study_info true
  end
end
