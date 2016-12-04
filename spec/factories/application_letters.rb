# == Schema Information
#
# Table name: application_letters
#
#  id          :integer          not null, primary key
#  motivation  :string
#  user_id     :integer          not null
#  event_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :application_letter do
    motivation "MyString"
    user
    event
    status nil
    factory :application_letter_deadline_over do
	    association :event, factory: :event, application_deadline: Date.yesterday
  	end
  end
end
