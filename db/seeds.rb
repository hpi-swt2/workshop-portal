# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Users
users = []

pupil = User.find_or_initialize_by(
    name: "Schueler",
    email: "schueler@example.com"
)
users.push(pupil)

teacher = User.find_or_initialize_by(
    name: "Lehrer",
    email: "lehrer@example.com"
)
users.push(teacher)

applicant = User.find_or_initialize_by(
    name: "Bewerber",
    email: "bewerber@example.com"
)
users.push(applicant)

# Set a password for every user
# They are only initialized, save them to the db
users.each do |user|
  user.password = "123456"
  user.save!
end

# A workshop
workshop = Workshop.find_or_create_by!(
    name: "Messung und Verarbeitung von Umweltdaten",
    description: "Workshop mit Phidgets und Etoys",
    max_participants: 20,
    active: true
)

# Pupil's profile
Profile.find_or_create_by!(
    cv: "Ich habe mich zu keinem Workshop beworben",
    user: pupil
)

# Teacher's profile
Profile.find_or_create_by!(
    cv: "Ich bin ein Lehrer. Ich frage Workshops für meine Schüler an.",
    user: teacher
)

# Applicant's profile
Profile.find_or_create_by!(
    cv: "Ich bin ein Schüler, der an Workshops teilnehmen möchte.",
    user: applicant
)

# Teacher's workshop request
Request.find_or_create_by!(
    topics: "Hardware-Entwicklung mit einem CAD-System",
    user: teacher
)

# Applicant's application letter
ApplicationLetter.find_or_create_by!(
    motivation: "Ich würde sehr gerne an eurem Workshop teilnehmen",
    user: applicant,
    workshop: workshop
)
