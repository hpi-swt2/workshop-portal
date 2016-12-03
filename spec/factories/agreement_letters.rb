# == Schema Information
#
# Table name: agreement_letters
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  event_id    :integer          not null
#  path        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryGirl.define do
  factory :agreement_letter do
    path { Rails.root.join('storage/agreement_letters/foo.pdf').to_s }
    user
    event
  end
end
