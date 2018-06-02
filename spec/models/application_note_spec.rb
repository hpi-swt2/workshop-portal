# == Schema Information
#
# Table name: application_notes
#
#  id                    :integer          not null, primary key
#  note                  :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  application_letter_id :integer
#
# Indexes
#
#  index_application_notes_on_application_letter_id  (application_letter_id)
#

require 'rails_helper'

RSpec.describe ApplicationNote, type: :model do

  it "is created by application_note factory" do
    application = FactoryGirl.create(:application_letter)
    note = FactoryGirl.build(:application_note, application_letter: application, note: "This is a note.")
    expect(note).to be_valid
  end

  it "not valid without application_letter" do
    note = FactoryGirl.build(:application_note,  note: "This is a note.")
    expect(note).to_not be_valid
  end

  it "not valid without note" do
    application = FactoryGirl.create(:application_letter)
    note = FactoryGirl.build(:empty_application_note, application_letter: application)
    expect(note).to_not be_valid
  end
end
