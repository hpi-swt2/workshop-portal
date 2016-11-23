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
