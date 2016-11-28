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
  has_many :application_notes
  
  validates :user, :event, presence: true

  # Checks if the deadline is over
  #
  # @param none
  # @return [Boolean] true if deadline is over
  def after_deadline?

    # hardcode deadline until
    # event model is ready in #18 - US_1.4: Application deadline
    deadline = DateTime.new(2016,9,1,17)

    now = Time.now.utc.to_datetime
    now > deadline
  end

end
