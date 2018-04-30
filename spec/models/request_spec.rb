# == Schema Information
#
# Table name: requests
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  form_of_address        :integer
#  first_name             :string
#  last_name              :string
#  phone_number           :string
#  school_street          :string
#  email                  :string
#  topic_of_workshop      :text
#  time_period            :text
#  number_of_participants :integer
#  knowledge_level        :string
#  annotations            :text
#  status                 :integer          default(0)
#  school_zip_code_city   :string
#  contact_person         :string
#  notes                  :text
#  grade                  :string
#

require 'rails_helper'

describe Request do

  it "is created by request factory" do
    request = FactoryGirl.build(:request)
    expect(request).to be_valid
  end
end
