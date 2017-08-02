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

  validate :validate_end_not_before_start

  def validate_end_not_before_start
    if end_date < start_date
      errors.add(:end_date, I18n.t('date_range.errors.end_before_start'))
    end
  end

  def to_s
    if start_date == end_date
      I18n.l(start_date)
    else
      I18n.l(start_date) + ' ' + I18n.t('date_range.pronouns.to') + ' ' + I18n.l(end_date)
    end
  end
end
