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

  ROLES = %i[pupil tutor organizer admin]

  def role?(base_role)
    return false unless role

    ROLES.index(base_role) <= ROLES.index(role.to_sym)
  end

  def set_default_role
    self.role ||= :pupil
  end

  def events
    accepted_applications = self.application_letters.select { |a| a.status == true }
    accepted_applications.collect { |a| a.event }
  end

  def agreement_letter_for_event?(given_event)
    fitting_agreement_letters = self.agreement_letters.select { |letter| letter.event == given_event }
	return false unless fitting_agreement_letters.length == 1
	return true
  end
  
  def agreement_letter_for_event(given_event)
    fitting_agreement_letters = self.agreement_letters.select { |letter| letter.event == given_event }
	return false unless fitting_agreement_letters.length == 1
	return fitting_agreement_letters[0]
  end
  
  def older_than_18_at_start_date_of_event?(given_event)
    event_start = given_event.start_date
    event_start_is_before_birthday = event_start.month > self.profile.birth_date.month || (event_start.month == self.profile.birth_date.month && event_start.day >= self.profile.birth_date.day)
    age_at_event_start = event_start.year - self.profile.birth_date.year - (event_start_is_before_birthday ? 0 : 1)
	return false unless age_at_event_start >= 18
	return true
  end
  
  has_one :profile
  has_many :application_letters
  has_many :requests

  # Returns the number of previously accepted applications from the user
  #
  # @param none
  # @return [Int] of number of accepted applications
  def accepted_application_count
    ApplicationLetter.where(:user_id => id, :status => true).count()
  end

  # Returns the number of previously rejected applications from the user
  #
  # @param none
  # @return [Int] of number of rejected applications
  def rejected_application_count
    ApplicationLetter.where(:user_id => id, :status => false).count()
  end

end
