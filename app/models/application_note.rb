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

class ApplicationNote < ActiveRecord::Base
  belongs_to :application_letter

  validates_presence_of :application_letter
  validates :note, presence: true
end
