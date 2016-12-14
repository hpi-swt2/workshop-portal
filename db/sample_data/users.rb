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