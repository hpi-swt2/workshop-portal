# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  date_ranges      :Collection
#  active           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Event < ActiveRecord::Base
  UNREASONABLY_LONG_DATE_SPAN = 300

  has_many :application_letters
  has_many :agreement_letters

  validates :max_participants, numericality: { only_integer: true, greater_than: 0 }
  
  # Returns all participants for this event in following order:
  # 1. All participants that have to submit an letter of agreement but did not yet do so, ordered by name.
  # 2. All participants that have to submit an letter of agreement and did do so, ordered by name.
  # 3. All participants that do not have to submit an letter of agreement, ordered by name.
  #
  # @param none
  # @return [Array<User>] the event's participants in that order.
  def participants_by_agreement_letter
    @participants = self.participants
	@participants.sort { |x, y| self.compare_participants_by_agreement(x,y) }
  end
  
  has_many :date_ranges

  validates :max_participants, numericality: { only_integer: true, greater_than: 0 }
  validate :has_date_ranges


  # @return the minimum start_date over all date ranges
  def start_date
    (date_ranges.min { |a,b| a.start_date <=> b.start_date }).start_date
  end

  # @return the minimum end_date over all date ranges
  def end_date
    (date_ranges.max { |a,b| a.end_date <=> b.end_date }).end_date
  end

  # @return whether this event appears unreasonably long as defined by
  #         the corresponding constant
  def unreasonably_long
    end_date - start_date > Rails.configuration.unreasonably_long_event_time_span
  end

  # validation function on whether we have at least one date range
  def has_date_ranges
    errors.add(:base, 'Bitte mindestens eine Zeitspanne auswählen!') if date_ranges.blank?
  end
  
  # Returns the participants whose application for this Event has been accepted
  #
  # @param none
  # @return [Array<User>] the event's participants
  def participants
    accepted_applications = application_letters.where(status: ApplicationLetter.statuses[:accepted])
    accepted_applications.collect { |a| a.user }
  end

  # Returns the agreement letter a user submitted for this event
  #
  # @param user [User] the user whose agreement letter we want
  # @return [AgreementLetter, nil] the user's agreement letter or nil
  def agreement_letter_for(user)
    self.agreement_letters.where(user: user).take
  end

  enum kind: [ :workshop, :camp ]

  # Returns whether all application_letters are classified or not
  #
  # @param none
  # @return [Boolean] if status of all application_letters is not pending
  def applications_classified?
    application_letters.all? { |application_letter| application_letter.status != 'pending' }
  end

  # Returns a string of all email addresses of rejected applications
  #
  # @param none
  # @return [String] Concatenation of all email addresses of rejected applications, seperated by ','
  def email_adresses_of_rejected_applicants
    #rejected_applications = application_letters.select { |application_letter| application_letter.status == 'rejected' }
    rejected_applications = application_letters.where(status: ApplicationLetter.statuses[:rejected])
    rejected_applications.map{ |applications_letter| applications_letter.user.email }.join(',')
  end

  # Returns a string of all email addresses of accepted applications
  #
  # @param none
  # @return [String] Concatenation of all email addresses of accepted applications, seperated by ','
  def email_adresses_of_accepted_applicants
    accepted_applications = application_letters.where(status: ApplicationLetter.statuses[:accepted])
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
    application_letters.where(status: ApplicationLetter.statuses[:accepted]).count
  end
  
  scope :draft_is, ->(draft) { where("draft = ?", draft) }
  
  protected
  # Compares two participants to achieve following order:
  # 1. All participants that have to submit an letter of agreement but did not yet do so, ordered by name.
  # 2. All participants that have to submit an letter of agreement and did do so, ordered by name.
  # 3. All participants that do not have to submit an letter of agreement, ordered by name.
  def compare_participants_by_agreement(participant1, participant2)
    if participant1.requires_agreement_letter_for_event?(self)
      if participant2.requires_agreement_letter_for_event?(self)
        return participant1.name <=> participant2.name
      end
      return 1
    end
    if participant2.requires_agreement_letter_for_event?(self)
      return -1
    end
    if participant1.agreement_letter_for_event?(self)
      if participant2.agreement_letter_for_event?(self)
        return participant1.name <=> participant2.name
      end
      return 1
    end
    if participant2.agreement_letter_for_event?(self)
      return -1
    end
    return participant1.name <=> participant2.name
  end

end
