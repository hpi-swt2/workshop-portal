# == Schema Information
#
# Table name: requests
#
#  id                     :integer          not null, primary key
#  annotations            :text
#  contact_person         :string
#  email                  :string
#  first_name             :string
#  form_of_address        :integer
#  grade                  :string
#  knowledge_level        :string
#  last_name              :string
#  notes                  :text
#  number_of_participants :integer
#  phone_number           :string
#  school_street          :string
#  school_zip_code_city   :string
#  status                 :integer          default("open")
#  time_period            :text
#  topic_of_workshop      :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

describe Request do

  it "is created by request factory" do
    request = FactoryGirl.build(:request)
    expect(request).to be_valid
  end
end
