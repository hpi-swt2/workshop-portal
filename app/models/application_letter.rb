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
  
  validates :user, :event, presence: true


  # Returns the number of accepted applications from the user without counting status of current event application
  #
  # @param none
  # @return [Int] of number of currently accepted applications
  def accepted_applications_count
    ApplicationLetter.where(user: user, status: true).where.not(event: event).count()
  end

  # Returns the number of accepted applications from the user without counting status of current event application
  #
  # @param none
  # @return [Int] of number of currently accepted applications
  def rejected_applications_count
    ApplicationLetter.where(user: user, status: false).where.not(event: event).count()
  end
end
