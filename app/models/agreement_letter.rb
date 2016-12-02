# == Schema Information
#
# Table name: agreement_letters
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  event_id    :integer          not null
#  path        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class AgreementLetter < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :user, :event, :path, presence: true
  MAX_SIZE = 300_000_000
  ALLOWED_MIMETYPE = "application/pdf"

  # Generates a unique filename for an AgreementLetter's file
  #
  # @raise [ArgumentError] if user or event are nil
  # @param none
  # @return [String] for the AgreementLetter's file name
  def filename
    if user.id.to_s.empty? or event.id.to_s.empty?
      raise ArgumentError.new("Cannot generate filename if user or event ids are empty")
    end
    "#{event.id}_#{user.id}.pdf"
  end
end
