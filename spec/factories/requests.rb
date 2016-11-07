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

FactoryGirl.define do
  factory :request do
    topics "MyString"
    user
  end
end
