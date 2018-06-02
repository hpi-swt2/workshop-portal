# == Schema Information
#
# Table name: application_notes
#
#  id                    :integer          not null, primary key
#  note                  :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  application_letter_id :integer
#
# Indexes
#
#  index_application_notes_on_application_letter_id  (application_letter_id)
#

FactoryGirl.define do
  factory :application_note do
    note "Hate this guy."
  end
  factory :empty_application_note, class: :application_note do
    note ""
  end
end
