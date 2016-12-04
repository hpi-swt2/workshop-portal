# == Schema Information
#
# Table name: application_letters
#
#  id          :integer          not null, primary key
#  motivation  :string
#  user_id     :integer          not null
#  event_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ApplicationLetter < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :application_notes
  
  validates :user, :event, presence: true

  # Checks if the deadline is over
  #
  # @param none
  # @return [Boolean] true if deadline is over
  def after_deadline?
    Date.today > event.application_deadline
  end

end
