class ApplicationNote < ActiveRecord::Base
  belongs_to :application_letter

  validates :application_letter, presence: true
  validates :note, presence: true
end
