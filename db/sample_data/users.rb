def user_password
  "123456"
end

def user_pupil
  User.new(
    email: "schueler@example.com",
    password: user_password,
    role: :pupil
  )
end

def user_teacher 
  User.new(
    email: "lehrer@example.com",
    password: user_password,
    role: :teacher
  )
end

def user_applicant
  User.new(
    email: "bewerber@example.com",
    password: user_password,
    role: :pupil
  )
end

def user_max
  User.new(
    email: "max@schueler.com",
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

def user_tobi
  User.new(
    email: "tobias.duerschmid@t-online.de",
    password: user_password,
    role: :pupil
  )
end

def user_organizer
  User.new(
    email: "organizer@workshops.hpi.de",
    password: user_password,
    role: :admin
  )
end

def user_coach
  User.new(
    email: "coach@workshops.hpi.de",
    password: user_password,
    role: :coach
  )
end