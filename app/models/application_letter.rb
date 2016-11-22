# == Schema Information
#
# Table name: application_letters
#
#  id          :integer          not null, primary key
#  motivation  :string
#  user_id     :integer          not null
#  workshop_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ApplicationLetter < ActiveRecord::Base
  belongs_to :user
  belongs_to :workshop
  has_many :application_notes
  
  validates :user, :workshop, presence: true
end
