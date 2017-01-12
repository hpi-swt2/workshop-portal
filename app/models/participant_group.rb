# == Schema Information
#
# Table name: participant_groups
#
#  id           	        :integer          not null, primary key
#  application_letter_id  :integer          not null
#  group                  :integer          not null
#
class ParticipantGroup < ActiveRecord::Base

  belongs_to :application_letter

  GROUPS = { 0 => 'none', 1 => 'darkblue', 2 => 'red', 3 => 'yellow', 4 => 'orange', 5 => 'lightgreen', 6 => 'purple', 7 => 'deeppink', 8 => 'darkgreen', 9 => 'lightblue', 10 => 'black' }
  GROUPS.default = 0

  validates :application_letter_id, presence: true
  validates_inclusion_of :group, :in => GROUPS.keys

end