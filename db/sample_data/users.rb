def user_password
  "123456"
end

def user_pupil
  User.new(
    name: "Schueler",
    email: "schueler@example.com",
    password: user_password,
    role: :pupil
  )
end

def user_teacher 
  User.new(
    name: "Lehrer",
    email: "lehrer@example.com",
    password: user_password,
    role: :teacher
  )
end

def user_applicant
  User.new(
    name: "Bewerber",
    email: "bewerber@example.com",
    password: user_password,
    role: :pupil
  )
end

def user_max
  User.new(
    name: "Max Mustermann",
    email: "max@schueler.com",
    password: user_password,
    role: :pupil
  )
end

def user_lisa
  User.new(
    name: "Lisa Ihde",
    email: "lisa@schueler.com",
    password: user_password,
    role: :pupil
  )
end

def user_tobi
  User.new(
    name: "Tobias Dürschmid",
    email: "tobias.duerschmid@t-online.de",
    password: user_password,
    role: :pupil
  )
end

def user_organizer
  User.new(
    name: "Organizer",
    email: "organizer@workshops.hpi.de",
    password: user_password,
    role: :admin
  )
end

def user_coach
  User.new(
    name: "Coach",
    email: "coach@workshops.hpi.de",
    password: user_password,
    role: :coach
  )
end