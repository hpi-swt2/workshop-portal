def user_password
  "123456"
end

def user_pupil
  User.new(
    email: "student@example.com",
    password: user_password,
    first_name: 'Katharina',
    last_name: 'Szyra',
    role: :pupil
  )
end

def user_teacher
  User.new(
    email: "lehrer@example.com",
    password: user_password,
    first_name: 'Klaus',
    last_name: 'Lagonos',
    role: :pupil
  )
end

def user_applicant
  User.new(
    email: "bewerber@example.com",
    password: user_password,
    first_name: 'Margarethe',
    last_name: 'Meininger',
    role: :pupil
  )
end

def user_max
  User.new(
    email: "max@schueler.com",
    password: user_password,
    first_name: 'Max',
    last_name: 'Emmentaler',
    role: :pupil
  )
end

def user_lisa
  User.new(
    email: "lisa@schueler.com",
    password: user_password,
    first_name: 'Lisa',
    last_name: 'Obermüller',
    role: :pupil
  )
end

def user_tobi
  User.new(
    email: "tobi@example.com",
    password: user_password,
    first_name: 'Tobias',
    last_name: 'Unger',
    role: :pupil
  )
end

def user_coach
  User.new(
    email: "coach@hpi.de",
    password: user_password,
    first_name: 'Leander',
    last_name: 'Sauerberg',
    role: :coach
  )
end

def user_organizer
  User.new(
    email: "organizer@hpi.de",
    password: user_password,
    first_name: 'Ann-Sophie',
    last_name: 'Müritz',
    role: :organizer
  )
end

def user_admin
  User.new(
    email: "admin@example.com",
    password: user_password,
    first_name: 'Ahmad',
    last_name: 'Mahmoud',
    role: :admin
  )
end
