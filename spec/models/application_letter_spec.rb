# == Schema Information
#
# Table name: application_letters
#
#  id          :integer          not null, primary key
#  motivation  :string
#  user_id     :integer          not null
#  workshop_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe ApplicationLetter do

  it "is created by application_letter factory" do
    application = FactoryGirl.build(:application_letter)
    expect(application).to be_valid
  end

  it "can't be created without mandatory fields" do
  	[:grade, :experience, :motivation, :coding_skills, :emergency_number, :vegeterian, :vegan, :allergic].each do |attr|
 	    application = FactoryGirl.build(:application_letter, attr => nil)
 	    expect(application).to_not be_valid
 	  end
  end
end
