# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  active           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Event < ActiveRecord::Base
  has_many :application_letters

  validates :max_participants, numericality: { only_integer: true, greater_than: 0 }

  # Returns the number of free places of the event, this value may be negative
  #
  # @param none
  # @return [Int] for number of free places available
  def compute_free_places
    max_participants - compute_occupied_places
  end

  # Returns the number of already occupied places of the event
  #
  # @param none
  # @return [Int] for number of occupied places
  def compute_occupied_places
    application_letters.where(status: ApplicationLetter.statuses[:accepted]).count
  end
end
