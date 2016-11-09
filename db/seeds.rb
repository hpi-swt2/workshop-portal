# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [
    {name: "Lazy Student", email: "lazy.student@example.com"},
    {name: "Willi Workshoprequester", email: "willi@example.com"},
    {name: "Arthur Applicant", email: "arthur@example.com"}
]

users.each do |user|
  initialized_user = User.find_or_initialize_by(
          name: user[:name],
          email: user[:email],
  )
  initialized_user.password = "test12345"
  initialized_user.save!
end

workshop_name = "Our first Workshop"
Workshop.find_or_create_by!(
    name: workshop_name,
    description: "The first workshop, we created",
    max_participants: 20,
    active: true
)

Profile.find_or_create_by!(
    cv: "I am lazy, so I did not apply to any Workshop or requested anything",
    user: User.find_by(email: users[0][:email])
)

Request.find_or_create_by!(
    topics: "Ruby on Rails Programming",
    user: User.find_by(email: users[1][:email])
)

Profile.find_or_create_by!(
    cv: "I have started with Rails and like to improve my knowledge in workshops. Would be cool if somebody could organize a Workshop",
    user: User.find_by(email: users[1][:email])
)

ApplicationLetter.find_or_create_by!(
    motivation: "I would really like to take part in the first workshop.",
    user: User.find_by(email: users[2][:email]),
    workshop: Workshop.find_by(name: workshop_name)
)
Profile.find_or_create_by!(
    cv: "No experience with workshops yet, so let me join.",
    user: User.find_by(email: users[2][:email])
)