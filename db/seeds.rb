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

# An event
event = Event.find_or_create_by!(
    name: "Messung und Verarbeitung von Umweltdaten",
    description: "Veranstaltung mit Phidgets und Etoys",
    max_participants: 20,
    active: true
)

# Pupil's profile
Profile.find_or_create_by!(
    user: pupil,
    first_name: "Karl",
    last_name: "Doe",
    gender: "männlich",
    birth_date: Date.parse('2000.11.29'),
    school: "Schule am Griebnitzsee",
    street_name: "Rudolf-Breitscheid-Str. 52",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "2019"
)

# Teacher's profile
Profile.find_or_create_by!(
    user: teacher,
    first_name: "Ernst",
    last_name: "Teacher",
    gender: "männlich",
    birth_date: Date.parse('1970.1.1'),
    school: "Schule am Griebnitzsee",
    street_name: "Domstraße 14",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "Bereits Abitur"
)

# Applicant's profile
Profile.find_or_create_by!(
    user: applicant,
    first_name: "Erika",
    last_name: "Mustermann",
    gender: "weiblich",
    birth_date: Date.parse('1999.08.14'),
    school: "Schule am Griebnitzsee",
    street_name: "Rudolf-Breitscheid-Str. 52",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "2017"
)

# Teacher's event request
Request.find_or_create_by!(
    topics: "Hardware-Entwicklung mit einem CAD-System",
    user: teacher
)

# Applicant's application letter
ApplicationLetter.find_or_create_by!(
    motivation: "Ich würde sehr gerne an eurer Veranstaltung teilnehmen",
    grade: 10,
    experience: "Internet",
    coding_skills: "HTML",
    emergency_number: "01234567891",
    vegeterian: false,
    vegan: false,
    allergic: false,
    allergies: "",
    status: ApplicationLetter.statuses[:pending],
    user: applicant,
    event: event
)
