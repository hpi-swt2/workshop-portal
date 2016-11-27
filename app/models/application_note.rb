# == Schema Information
#
# Table name: application_notes
#
#  id                     :integer          not null, primary key
#  application_letter_id  :integer          not null, foreign key
#  note                   :text             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class ApplicationNote < ActiveRecord::Base
  belongs_to :application_letter

  validates :application_letter, presence: true
  validates :note, presence: true
end
