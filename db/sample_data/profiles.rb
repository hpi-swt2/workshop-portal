def profile_pupil(user)
  Profile.new(
    user: user,
    first_name: "Karl",
    last_name: "Doe",
    gender: "male",
    birth_date: Date.parse('2005.11.29'),
    school: "Schule am Griebnitzsee",
    street_name: "Rudolf-Breitscheid-Str. 52",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "2019"
  )
end

def profile_pupil_max(user)
  Profile.new(
    user: user,
    first_name: "Max",
    last_name: "Mustermann",
    gender: "male",
    birth_date: Date.parse('2005.12.09'),
    school: "Musterschule",
    street_name: "Musterstraße 42",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "2018"
  )
end

def profile_teacher(user)
  Profile.new(
    user: user,
    first_name: "Ernst",
    last_name: "Teacher",
    gender: "male",
    birth_date: Date.parse('1970.1.1'),
    school: "Schule am Griebnitzsee",
    street_name: "Domstraße 14",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "Bereits Abitur"
  )
end

def profile_applicant(user)
  Profile.new(
    user: user,
    first_name: "Erika",
    last_name: "Mustermann",
    gender: "female",
    birth_date: Date.parse('2006.08.14'),
    school: "Schule am Griebnitzsee",
    street_name: "Rudolf-Breitscheid-Str. 52",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "2017"
  )
end

def profile_tobi(user)
  Profile.new(
    user: user,
    first_name: "Tobias",
    last_name: "Dürschmid",
    gender: "male",
    birth_date: Date.parse('1995.08.31'),
    school: "Goetheschule Ilmenau",
    street_name: "Stahnsdorfer Str.",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "Bereits Abitur"
  )
end

def profile_lisa(user)
  Profile.new(
      user: user,
      first_name: "Lisa",
      last_name: "Ihde",
      gender: "female",
      birth_date: Date.parse('1996.09.21'),
      school: "Sophie-Scholl-Gymnasium",
      street_name: "Stahnsdorfer Str.",
      zip_code: "14482",
      city: "Potsdam",
      state: "Brandenburg",
      country: "Deutschland",
      graduates_school_in: "Bereits Abitur"
  )
end