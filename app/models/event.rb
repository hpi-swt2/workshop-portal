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

  # Returns whether all application_letters are classified or not
  #
  # @param none
  # @return [Boolean] if all application_letter are classified
  def applicationsClassified?
    application_letters.all? { |application_letter| !application_letter.status.nil? }
  end

  # Returns a string of all email addresses of rejected applications
  #
  # @param none
  # @return [String] Concatenation of all email addresses of rejected applications, seperated by ','
  def compute_rejected_applications_emails
    rejected_applications = application_letters.select { |application_letter| !application_letter.status }
    rejected_applications.map{ |applications_letter| applications_letter.user.email }.join(',')
  end

  # Returns a string of all email addresses of accepted applications
  #
  # @param none
  # @return [String] Concatenation of all email addresses of accepted applications, seperated by ','
  def compute_accepted_applications_emails
    accepted_applications = application_letters.select { |application_letter| application_letter.status }
    accepted_applications.map{ |application_letter| application_letter.user.email }.join(',')
  end

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
    application_letters.where(status: true).count
  end
end
