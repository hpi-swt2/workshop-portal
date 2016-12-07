# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :profile do
    first_name  "Karl"
    last_name  "Doe"
    gender  "männlich"
    birth_date  15.years.ago
    school  "Schule am Griebnitzsee"
    street_name  "Rudolf-Breitscheid-Str. 52"
    zip_code  "14482"
    city  "Potsdam"
    state  "Babelsberg"
    country  "Deutschland"
    graduates_school_in "Bereits Abitur"
    user
    trait :low_values do
      first_name "Andreas"
      last_name "Andresen"
      birth_date 13.years.ago    # low age, but higher date
      gender "männlich"
    end

    trait :high_values do
      first_name "Zoe"
      last_name "Z"
      birth_date 20.years.ago
      gender "weiblich"
    end
  end

  factory :adult_profile, parent: :profile do
    birth_date  18.years.ago
  end

end
