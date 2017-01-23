def application_letter_applicant_gongakrobatik(user, event)
  ApplicationLetter.new(
    motivation: "Ich habe vor kurzem davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
    grade: 10,
    experience: "Über einen Facebookpost ihrer Seite bin ich auf das Angebot aufmerksam geworden",
    coding_skills: "HTML",
    emergency_number: "01234567891",
    vegetarian: false,
    vegan: false,
    allergic: false,
    allergies: "",
    user: user,
    event: event
  )
end

def application_letter_applicant_gongakrobatik_rejected(user, event)
  ApplicationLetter.new(
      motivation: "Ich habe vor kurzem davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
      grade: 10,
      experience: "Über einen Facebookpost ihrer Seite bin ich auf das Angebot aufmerksam geworden",
      coding_skills: "HTML",
      emergency_number: "01234567891",
      vegetarian: false,
      vegan: false,
      allergic: false,
      allergies: "",
      user: user,
      event: event,
      status: ApplicationLetter.statuses[:rejected]
  )
end

def application_letter_applicant_gongakrobatik_accepted(user, event)
  ApplicationLetter.new(
      motivation: "Den normalen Unterricht in der Schule finde ich ziemlich langweilig und würde mich darüber freuen, etwas über den Tellerrand zu schauen und spannende Dinge lernen. Ich arbeite sehr gerne im Team und freue mich darauf, Gleichgesinnte kennen zu lernen.",
      grade: 9,
      experience: "Über einen Zeitungsartikel",
      coding_skills: "For, While und If-Schleifen in Java",
      emergency_number: "01234567891",
      vegetarian: false,
      vegan: false,
      allergic: true,
      allergies: "Tomaten",
      user: user,
      event: event,
      status: ApplicationLetter.statuses[:accepted]
  )
end

def application_letter_applicant_programmierkurs_1(user, event)
  ApplicationLetter.new(
    motivation: "Den normalen Unterricht in der Schule finde ich ziemlich langweilig und würde mich darüber freuen, etwas über den Tellerrand zu schauen und spannende Dinge lernen. Ich arbeite sehr gerne im Team und freue mich darauf, Gleichgesinnte kennen zu lernen.",
    grade: 9,
    experience: "Über einen Zeitungsartikel",
    coding_skills: "For, While und If-Schleifen in Java",
    emergency_number: "01234567891",
    vegetarian: false,
    vegan: false,
    allergic: true,
    allergies: "Tomaten",
    user: user,
    event: event
  )
end

def application_letter_applicant_programmierkurs_2(user, event)
  ApplicationLetter.new(
    motivation: "Ich habe vor kurzem davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
    grade: 10,
    experience: "Suche im Internet",
    coding_skills: "keine",
    emergency_number: "01234567891",
    vegetarian: true,
    vegan: false,
    allergic: false,
    allergies: "",
    user: user,
    event: event
  )
end

def application_letter_applicant_programmierkurs_3(user, event)
  ApplicationLetter.new(
      motivation: "Ich habe vor LANGEM davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
      grade: 10,
      experience: "Suche im Internetz",
      coding_skills: "absolut keine",
      emergency_number: "01234567819",
      vegetarian: true,
      vegan: false,
      allergic: false,
      allergies: "",
      user: user,
      event: event
  )
end