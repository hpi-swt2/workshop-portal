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

FactoryGirl.define do
  factory :application_letter do
    motivation "MyString"
    status nil

    ignore do
      user
      workshop
    end

    after(:create) do |application_letter, evalutor|
      application_letter.user = evalutor.user
      application_letter.workshop = evalutor.workshop
    end
  end
end
