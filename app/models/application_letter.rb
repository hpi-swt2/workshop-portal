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
#  status      :integer
#
class ApplicationLetter < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :application_notes

  validates :user, :event, presence: true

  enum status: {accepted: 1, rejected: 0, pending: 2}

end
