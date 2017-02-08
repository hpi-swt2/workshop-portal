def profile_pupil(user)
  Profile.new(
    user: user,
    first_name: "Karl",
    last_name: "Schüler",
    gender: "male",
    birth_date: Date.parse('2005.11.29'),
    street_name: "Rudolf-Breitscheid-Str. 52",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
  )
end

def profile_pupil_max(user)
  Profile.new(
    user: user,
    first_name: "Max",
    last_name: "Mustermann",
    gender: "male",
    birth_date: Date.parse('2005.12.09'),
    street_name: "Musterstraße 42",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    discovery_of_site: "Mein Lehrer hat mir davon erzählt"
  )
end

def profile_teacher(user)
  Profile.new(
    user: user,
    first_name: "Ernst",
    last_name: "Teacher",
    gender: "male",
    birth_date: Date.parse('1970.1.1'),
    street_name: "Domstraße 14",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    discovery_of_site: "Werbung im Internet"
  )
end

def profile_applicant(user)
  Profile.new(
    user: user,
    first_name: "Erika",
    last_name: "Mustermann",
    gender: "female",
    birth_date: Date.parse('2006.08.14'),
    street_name: "Rudolf-Breitscheid-Str. 52",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    discovery_of_site: "Von meinem Bruder"
  )
end

def profile_tobi(user)
  Profile.new(
    user: user,
    first_name: "Tobias",
    last_name: "Dürschmid",
    gender: "male",
    birth_date: Date.parse('1995.08.31'),
    street_name: "Stahnsdorfer Str.",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
  )
end

def profile_coach(user)
  Profile.new(
    user: user,
    first_name: "Tom",
    last_name: "Betreuer",
    gender: "male",
    birth_date: Date.parse('1995.08.31'),
    street_name: "Stahnsdorfer Str.",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
  )
end

def profile_organizer(user)
  Profile.new(
      user: user,
      first_name: "Lisa",
      last_name: "Organisatorin",
      gender: "female",
      birth_date: Date.parse('1996.09.21'),
      street_name: "Stahnsdorfer Str.",
      zip_code: "14482",
      city: "Potsdam",
      state: "Brandenburg",
      country: "Deutschland",
  )
end

def profile_admin(user)
  Profile.new(
      user: user,
      first_name: "Karl",
      last_name: "Administrator",
      gender: "female",
      birth_date: Date.parse('1996.06.03'),
      street_name: "Stahnsdorfer Str.",
      zip_code: "14482",
      city: "Potsdam",
      state: "Brandenburg",
      country: "Deutschland",
  )
end

def profile_lisa(user)
  Profile.new(
      user: user,
      first_name: "Lisa",
      last_name: "Ihde",
      gender: "female",
      birth_date: Date.parse('1996.09.21'),
      street_name: "Stahnsdorfer Str.",
      zip_code: "14482",
      city: "Potsdam",
      state: "Brandenburg",
      country: "Deutschland",
  )
end