def application_letter_applicant_gongakrobatik(user, event)
  ApplicationLetter.new(
    motivation: "Ich habe vor kurzem davon erfahren und war direkt hellaufbegeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren",
    grade: 10,
    experience: "Über einen Facebookpost ihrer Seite bin ich auf das Angebot aufmerksam geworden",
    coding_skills: "HTML",
    emergency_number: "01234567891",
    vegeterian: false,
    vegan: false,
    allergic: false,
    allergies: "",
    user: user,
    event: event
  )
end