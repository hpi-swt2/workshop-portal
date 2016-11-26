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
#  status      :boolean

FactoryGirl.define do
  factory :agreement_letter do
    path { Rails.root.join('storage/agreement_letters/foo.pdf').to_s }
    user
    event
  end
end
