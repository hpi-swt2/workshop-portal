# == Schema Information
#
# Table name: workshops
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  max_participants :integer
#  active           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

describe Workshop do

  it "is created by workshop factory" do
    workshop = FactoryGirl.build(:workshop)
    expect(workshop).to be_valid
  end

  it "computes the number of free places" do
    workshop = FactoryGirl.create(:workshop)
    application_letter = FactoryGirl.create(:application_letter, user: FactoryGirl.create(:user), workshop: workshop)
    workshop.application_letters.push(application_letter)

    expect(workshop.compute_free_places).to eq(workshop.max_participants - workshop.application_letters.count) #TODO: count only those that are accepted
  end
end
