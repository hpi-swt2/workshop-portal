class AgreementLetter < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :user, :event, :path, presence: true
  def filename
    if user.id.to_s.empty? or event.id.to_s.empty?
      raise ArgumentError.new("Cannot generate filename if user or event ids are empty")
    end
    "#{event.id}_#{user.id}.pdf"
  end
end
