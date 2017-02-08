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
    event: event
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
      status: ApplicationLetter.statuses[:rejected]
  )
end

def application_letter_applicant_gongakrobatik_accepted(user, event)
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
      status: ApplicationLetter.statuses[:accepted]
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
    custom_application_fields: ['Dooodlejump', '8', 'Java']
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
    custom_application_fields: ['Snapchat', '10', 'Python']
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
      custom_application_fields: ['Facebook, Twitter', '9', 'C++, C#']
  )
end
