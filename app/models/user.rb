# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :agreement_letters

  before_create :set_default_role

  ROLES = %i[pupil coach organizer admin]

  def role?(base_role)
    return false unless role

    ROLES.index(base_role) <= ROLES.index(role.to_sym)
  end

  def set_default_role
    self.role ||= :pupil
  end

  # Returns the events for which the user's application has been accepted
  #
  # @param none
  # @return [Array<Event>] the user's events
  def events
    accepted_applications = application_letters.where(status: ApplicationLetter.statuses[:accepted])
    accepted_applications.collect { |a| a.event }
  end

  # Returns true iff. user has submitted an agreement_letter for the given event
  #
  # @param [Event] given_event
  # @return [Boolean]
  def agreement_letter_for_event?(given_event)
    return !self.agreement_letter_for_event(given_event).nil?
  end
  
  # Returns the agreement letter the user has submitted for given_event. Returns Nil if no such letter exists.
  #
  # @param [Event] given_event
  # @return [AgreementLetter, Nil]
  def agreement_letter_for_event(given_event)
    fitting_agreement_letters = self.agreement_letters.select { |letter| letter.event == given_event }
	return fitting_agreement_letters[0]
  end
  
  # Returns true iff. user is at least 18 years old at the start date of given_event
  #
  # @param [Event] given_event
  # @return [Boolean]
  def requires_agreement_letter_for_event?(given_event)
    return self.older_than_required_age_at_start_date_of_event?(given_event, 18)
  end
  
  # Returns true iff. the age of user is age or more at the start_date of given_event. Returns false if age of user is unknown.
  #
  # @param given_event [Event], age [Integer]
  # @return [Boolean]
  def older_than_required_age_at_start_date_of_event?(given_event, age)
    return false unless self.profile
    event_start = given_event.start_date
    event_start_is_before_birthday = event_start.month > self.profile.birth_date.month || (event_start.month == self.profile.birth_date.month && event_start.day >= self.profile.birth_date.day)
    age_at_event_start = event_start.year - self.profile.birth_date.year - (event_start_is_before_birthday ? 0 : 1)
	return age_at_event_start >= age
  end
  
  has_one :profile
  has_many :application_letters
  has_many :agreement_letters
  has_many :requests

  # Returns the number of accepted applications from the user without counting status of current event application
  #
  # @param [Event] current event (which application status will be excluded)
  # @return [Int] of number of currently accepted applications
  def accepted_applications_count(event)
    ApplicationLetter.where(user_id: id, status: true).where.not(event: event).count()
  end

  # Returns the number of accepted applications from the user without counting status of current event application
  #
  # @param current event (which application status will be excluded)
  # @return [Int] of number of currently accepted applications
  def rejected_applications_count(event)
    ApplicationLetter.where(user_id: id, status: false).where.not(event: event).count()
  end

end
