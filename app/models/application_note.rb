# == Schema Information
#
# Table name: application_notes
#
#  id                    :integer          not null, primary key
#  note                  :text
#  application_letter_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
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
