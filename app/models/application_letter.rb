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
#  status      :integer          not null
#
class ApplicationLetter < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  has_many :application_notes
  serialize :custom_application_fields, Array

  validates_presence_of :user, :event, :motivation, :emergency_number, :organisation
  #Use 0 as default for hidden event applications
  validates :vegetarian, :vegan, :allergic, inclusion: { in: [true, false] }
  validates :vegetarian, :vegan, :allergic, exclusion: { in: [nil] }
  validate :deadline_cannot_be_in_the_past, :if => Proc.new { |letter| !(letter.status_changed? || letter.status_notification_sent_changed?) }
  validate :status_notification_sent_cannot_be_changed, :if => Proc.new { |letter| letter.status_notification_sent_changed? }
  validate :status_cannot_be_changed, :if => Proc.new { |letter| letter.status_changed? }

  enum status: {accepted: 1, rejected: 0, pending: 2, alternative: 3, canceled: 4}
  validates :status, inclusion: { in: statuses.keys }


  # Returns an array of selectable statuses
  #
  # @param none
  # @return [Array <String>] array of selectable statuses
  def self.selectable_statuses
    ["accepted","rejected","pending","alternative"]
  end

  # Checks if the deadline is over
  # additionally only return if event and event.application_deadline is present
  #
  # @param none
  # @return [Boolean] true if deadline is over
  def after_deadline?
    event.after_deadline? if event.present?
  end

  # Checks if it is allowed to change the status of the application
  #
  # @param none
  # @return [Boolean] true if status changes are allowed
  def status_change_allowed?
    if event.phase == :execution
      (status_was == 'accepted' && status == 'canceled') || (status_was == 'alternative' && status == 'accepted') || (status_was == 'rejected' && status == 'accepted' && !event.has_alternative_application_letters?)
    elsif event.phase == :selection && event.participant_selection_locked
      false
    else
      true
    end
  end

  # Checks if it is allowed to set the status_notification_sent flag
  #
  # @param none
  # @return [Boolean] true if it can be changed
  def status_notification_sent_change_allowed?
    event.phase == :selection || event.phase == :execution
  end

  # Validator for after_deadline?
  # Adds error
  def deadline_cannot_be_in_the_past
    if after_deadline?
      errors.add(:event, I18n.t("application_letters.form.warning"))
    end
  end
  
  # Since EatingHabits are persited in booleans we need to generate a 
  # EatingHabitStateCode to allow sorting
  # US 28_4.5
   
   def get_eating_habit_state
     eating_habit_state = 0
     eating_habit_state += 4 if vegetarian
     eating_habit_state += 5 if vegan
     eating_habit_state += 99 if allergic
     return eating_habit_state
   end

  # Chooses right status based on status and event deadline
  #
  # @param none
  # @return [String] to display on the website
  def status_type
    case ApplicationLetter.statuses[status]
      when ApplicationLetter.statuses[:accepted]
        return I18n.t("application_status.accepted")
      when ApplicationLetter.statuses[:rejected]
        return I18n.t("application_status.rejected")
      when ApplicationLetter.statuses[:pending]
        if after_deadline?
          return I18n.t("application_status.pending_after_deadline")
        else
          return I18n.t("application_status.pending_before_deadline")
        end
      when ApplicationLetter.statuses[:canceled]
        return I18n.t("application_status.canceled")
      else
        return I18n.t("application_status.alternative")
    end
  end

  # Validator for status_change_allowed?
  # Adds error
  def status_cannot_be_changed
    unless status_change_allowed?
      errors.add(:event, I18n.t('application_letters.validation.status_cannot_be_changed'))
    end
  end

  # Validator for status_change_allowed?
  # Adds error
  def status_notification_sent_cannot_be_changed
    unless status_notification_sent_change_allowed?
      errors.add(:event, I18n.t('application_letters.validation.status_notification_sent_cannot_be_changed'))
    end
  end

  # Returns the age of the user based on the date the event starts
  #
  # @param none
  # @return [Int] for age as number of years
  def applicant_age_when_event_starts
    user.profile.age_at_time(event.start_date)
  end

  # Returns an array of eating habits (including allergies, vegan and vegetarian)
  #
  # @param none
  # @return [Array <String>] array of eating habits, empty if none
  def eating_habits
    habits = Array.new
    habits.push(ApplicationLetter.human_attribute_name(:vegetarian)) if vegetarian
    habits.push(ApplicationLetter.human_attribute_name(:vegan)) if vegan
    habits.push(ApplicationLetter.human_attribute_name(:allergies)) if allergic
    habits
  end

  def allergic
    not allergies.empty?
  end
end
