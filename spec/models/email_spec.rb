require 'rails_helper'

describe Email do
  let(:valid_email) {FactoryGirl.build(:email) }
  let(:invalid_email) { FactoryGirl.build(:email, subject: nil) }
  let(:mulitline_email) { FactoryGirl.build(:email, content: "Email-content \n Email-Content") }

  it 'is buildd by factory' do
    expect(valid_email).to be_valid
  end

  it 'should not be valid without content' do
    expect(invalid_email).to_not be_valid
  end

  it 'should convert ruby line breaks to html <br>' do
    expect(mulitline_email).to_not include('\n')
  end
end