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

  it "dummy test, add real test" do
    workshop = FactoryGirl.build(:workshop)
    expect(workshop).to be_valid
  end
end
