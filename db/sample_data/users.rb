def user_password
  "123456"
end

def user_pupil
  User.new(
    email: "hendrik.raetz@student.hpi.de",
    password: user_password,
    role: :pupil
  )
end

def user_teacher
  User.new(
    email: "lehrer@example.com",
    password: user_password,
    role: :pupil
  )
end

def user_applicant
  User.new(
    email: "bewerber@example.com",
    password: user_password,
    role: :pupil
  )
end

def user_ralf
  User.new(
    email: "ralf.teusner@hpi.de",
    password: user_password,
    role: :pupil
  )
end

def user_lisa
  User.new(
    email: "lisa@schueler.com",
    password: user_password,
    role: :pupil
  )
end

def user_keven
  User.new(
    email: "keven.richly@hpi.de",
    password: user_password,
    role: :pupil
  )
end

def user_coach
  User.new(
    email: "coach@hpi.de",
    password: user_password,
    role: :coach
  )
end

def user_organizer
  User.new(
    email: "organizer@hpi.de",
    password: user_password,
    role: :organizer
  )
end

def user_admin
  User.new(
    email: "admin@hpi.de",
    password: user_password,
    role: :admin
  )
end
