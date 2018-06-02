# == Schema Information
#
# Table name: agreement_letters
#
#  id         :integer          not null, primary key
#  path       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_agreement_letters_on_event_id  (event_id)
#  index_agreement_letters_on_user_id   (user_id)
#

FactoryGirl.define do
  factory :agreement_letter do
    path { Rails.root.join('storage/agreement_letters/foo.pdf').to_s }
    user
    event

    factory :real_agreement_letter do
    	path { Rails.root.join('spec/testfiles/real_agreement_letter.pdf').to_s }
    end

  end
end
