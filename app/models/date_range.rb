# == Schema Information
#
# Table name: date_ranges
#
#  id               :integer          not null, primary key
#  event_id         :integer          index
#  start_date       :date
#  end_date         :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null

#
class DateRange < ActiveRecord::Base


  belongs_to :event

  validate :validate_start_date_not_in_past
  validate :validate_end_not_before_start

  def validate_start_date_not_in_past
    if start_date < Date.current
      errors.add(:start_date, "darf nicht in der Vergangenheit liegen.")
    end
    if end_date < Date.current
      errors.add(:end_date, "darf nicht in der Vergangenheit liegen.")
    end
  end

  def validate_end_not_before_start
    if end_date < start_date
      errors.add(:end_date, "kann nicht vor Start-Datum liegen.")
    end
  end

  def to_s
    if start_date == end_date
      start_date
    else
      I18n.l(start_date) + ' ' + I18n.t('date_range.to') + ' ' + I18n.l(end_date)
    end
  end
end
