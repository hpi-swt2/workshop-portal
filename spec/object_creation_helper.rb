def create_accepted_application_with(event, last_name, allergic, vegan, vegetarian)
  user = FactoryGirl.create :user, last_name: last_name # TODO: In the only test obviously first names are used
  application_letter = FactoryGirl.create(:application_letter, :accepted,
    user: user, event: event, vegan: vegan, vegetarian: vegetarian, allergies: allergic ? "many" : "")
end
