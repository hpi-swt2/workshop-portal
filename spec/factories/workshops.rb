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

FactoryGirl.define do
  factory :workshop do
    name "Workshop-Name"
    description "Workshop-Description"
    max_participants 1
    active false
  end
  
  factory :workshop_with_accepted_applications do
	name "Workshop-Name"
    description "Workshop-Description"
    max_participants 20
    active false
	transient do
		application_letters_count 5
	end
	
	after(:create) do |workshop, evaluator|
		create_list(:accepted_application_letter, evaluator.application_letters_count, workshop: workshop)
	end
  end
end
