require 'rails_helper'

RSpec.describe AgreementLetter, type: :model do
  it "returns its id as filename" do
    @agreement_letter = FactoryGirl.create(:agreement_letter)
    user_id = @agreement_letter.user.id
    event_id = @agreement_letter.event.id
    expect(user_id.to_s).not_to be_empty
    expect(event_id.to_s).not_to be_empty
    expect(@agreement_letter.filename).to eq "#{event_id.to_s}_#{user_id.to_s}.pdf"
  end

  it "throws an exception filename has an empty component" do
    @agreement_letter = FactoryGirl.create(:agreement_letter)
    @agreement_letter.user.id = nil
    expect { @agreement_letter.filename }.to raise_error ArgumentError
  end

end
