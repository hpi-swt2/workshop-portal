def create_accepted_application_with(event, last_name, allergic, vegan, vegetarian)
  user = FactoryGirl.create(:user)
  profile = FactoryGirl.create(:profile, user: user, last_name: last_name)
  application_letter = FactoryGirl.create(:application_letter_accepted,
    user: user, event: event, vegan: vegan, vegetarian: vegetarian, allergic: allergic)
end
