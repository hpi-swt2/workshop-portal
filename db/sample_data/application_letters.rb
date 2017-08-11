def application_letter_applicant_gongakrobatik(user, event)
  ApplicationLetter.new(
    motivation: "Ich habe vor kurzem davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
    emergency_number: "01234567891",
    organisation: "Schule am Griebnitzsee",
    vegetarian: false,
    vegan: false,
    allergies: "",
    annotation: "Euer Angebot find ich echt super.",
    user: user,
    event: event,
    status: ApplicationLetter.statuses[:pending],
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

def application_letter_applicant_gongakrobatik_rejected(user, event)
  ApplicationLetter.new(
      motivation: "Ich habe vor kurzem davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
      emergency_number: "01234567891",
      organisation: "Schule am Griebnitzsee",
      vegetarian: false,
      vegan: false,
      allergies: "",
      annotation: "",
      user: user,
      event: event,
      status: ApplicationLetter.statuses[:pending],
      first_name: "Lisa",
      last_name: "Ihde",
      gender: "female",
      birth_date: Date.parse('1996.09.21'),
      street_name: "Stahnsdorfer Str.",
      zip_code: "14482",
      city: "Potsdam",
      state: "Brandenburg",
      country: "Deutschland"
  )
end

def application_letter_applicant_gongakrobatik_accepted(user, event)
  ApplicationLetter.new(
      motivation: "Den normalen Unterricht in der Schule finde ich ziemlich langweilig und würde mich darüber freuen, etwas über den Tellerrand zu schauen und spannende Dinge lernen. Ich arbeite sehr gerne im Team und freue mich darauf, Gleichgesinnte kennen zu lernen.",
      emergency_number: "01234567891",
      organisation: "Schule am Griebnitzsee",
      vegetarian: false,
      vegan: true,
      allergies: "Tomaten",
      annotation: "Euer Angebot find ich echt super.",
      user: user,
      event: event,
      status: ApplicationLetter.statuses[:pending],
      first_name: "Emma",
      last_name: "Klein",
      gender: "female",
      birth_date: Date.parse('1992.08.11'),
      street_name: "Stahnsdorfer Str. 154B",
      zip_code: "14482",
      city: "Potsdam",
      state: "Brandenburg",
      country: "Deutschland"
  )
end

def application_letter_applicant_programmierkurs_1(user, event)
  ApplicationLetter.new(
    motivation: "Den normalen Unterricht in der Schule finde ich ziemlich langweilig und würde mich darüber freuen, etwas über den Tellerrand zu schauen und spannende Dinge lernen. Ich arbeite sehr gerne im Team und freue mich darauf, Gleichgesinnte kennen zu lernen.",
    emergency_number: "01234567891",
    organisation: "Schule am Griebnitzsee",
    vegetarian: false,
    vegan: false,
    allergies: "Tomaten",
    annotation: "Euer Angebot find ich echt super.",
    user: user,
    event: event,
    custom_application_fields: ['Dooodlejump', '8', 'Java'],
    status: ApplicationLetter.statuses[:accepted],
    first_name: "Marlon",
    last_name: "Ondra",
    gender: "male",
    birth_date: Date.parse('1999.04.27'),
    street_name: "Stahnsdorfer Str. 140A",
    zip_code: "14482",
    city: "Potsdam",
    state: "Brandenburg",
    country: "Deutschland"
  )
end

def application_letter_applicant_programmierkurs_2(user, event)
  ApplicationLetter.new(
    motivation: "Ich habe vor kurzem davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
    emergency_number: "01234567891",
    organisation: "Schule am Griebnitzsee",
    vegetarian: true,
    vegan: false,
    allergies: "",
    annotation: "Euer Angebot find ich echt super.",
    user: user,
    event: event,
    custom_application_fields: ['Snapchat', '10', 'Python'],
    status: ApplicationLetter.statuses[:rejected],
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

def application_letter_applicant_programmierkurs_3(user, event)
  ApplicationLetter.new(
      motivation: "Ich habe vor LANGEM davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
      emergency_number: "01234567819",
      organisation: "Schule am Griebnitzsee",
      vegetarian: true,
      vegan: false,
      allergies: "",
      annotation: "Euer Angebot find ich echt super.",
      user: user,
      event: event,
      custom_application_fields: ['Facebook, Twitter', '9', 'C++, C#'],
      status: ApplicationLetter.statuses[:accepted],
      first_name: "Hendrik",
      last_name: "Schüler",
      gender: "male",
      birth_date: Date.parse('1995.11.29'),
      street_name: "Rudolf-Breitscheid-Str. 52",
      zip_code: "14482",
      city: "Potsdam",
      state: "Brandenburg",
      country: "Deutschland"
  )
end
