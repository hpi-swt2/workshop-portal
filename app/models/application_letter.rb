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

  validates :user, :event, :experience, :motivation, :coding_skills, :emergency_number, presence: true
  validates :grade, presence: true, numericality: { only_integer: true }
  validates :vegeterian, :vegan, :allergic, inclusion: { in: [true, false] }
  validates :vegeterian, :vegan, :allergic, exclusion: { in: [nil] }
  validate :deadline_cannot_be_in_the_past, :if => Proc.new { |letter| !(letter.status_changed?) }

  enum status: {accepted: 1, rejected: 0, pending: 2}

  # Checks if the deadline is over
  #
  # @param none
  # @return [Boolean] true if deadline is over
  def after_deadline?
    Date.today > event.application_deadline if event.present?
  end

  # Validator for after_deadline?
  # Adds error
  def deadline_cannot_be_in_the_past
    if after_deadline?
      errors.add(:event, I18n.t("application_letters.form.warning"))
    end
  end
end
