def profile_pupil(user)
  Profile.new(
    user: user,
    first_name: "Karl",
    last_name: "Doe",
    gender: "male",
    birth_date: Date.parse('2000.11.29'),
    school: "Schule am Griebnitzsee",
    street_name: "Rudolf-Breitscheid-Str. 52",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "2019"
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
    birth_date: Date.parse('1999.08.14'),
    school: "Schule am Griebnitzsee",
    street_name: "Rudolf-Breitscheid-Str. 52",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland",
    graduates_school_in: "2017"
  )
end