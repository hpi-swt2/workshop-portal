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

  GROUPS = { 0 => '0', 1 => '00008B', 2 => 'FF0000', 3 => 'FFFF00', 4 => 'FFA500', 5 => '90EE90', 6 => '800080', 7 => 'FF1493', 8 => '006400', 9 => 'ADD8E6', 10 => '000000' }
  GROUPS.default = 0

  validates :application_letter_id, presence: true
  validates_inclusion_of :group, :in => GROUPS.keys

end
