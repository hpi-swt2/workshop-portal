# == Schema Information
#
# Table name: requests
#
#  id         :integer          not null, primary key
#  topics     :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Request do

  it "is created by request factory" do
    request = FactoryGirl.build(:request)
    expect(request).to be_valid
  end
end
