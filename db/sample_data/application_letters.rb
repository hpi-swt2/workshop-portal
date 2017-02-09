def application_letter_1(user, event)
  ApplicationLetter.new(
    motivation: "Ich kann selber noch nicht programmieren, aber will es gerne lernen. Deshalb will ich ins Sommer-Camp.",
    emergency_number: "01234567891",
    organisation: "Schule am Griebnitzsee",
    vegetarian: false,
    vegan: false,
    allergies: "",
    annotation: "Euer Angebot find ich echt super.",
    user: user,
    event: event,
    status: ApplicationLetter.statuses[:pending]
  )
end

def application_letter_2(user, event)
  ApplicationLetter.new(
      motivation: "Ich habe vor kurzem davon erfahren und war direkt hellauf begeistert. Gerne würde ich mich bei Ihnen näher über das Thema informieren. Ich bin absoluter Experte im Programmieren. In meiner Klasse bin ich der Einzige, der sich mit For-Schleifen und If-Schleifen auskennt. Mittlerweile spiele ich ein bisschen mit Rekursion herum. Vielleicht gibt es auf dem Camp auch andere Leute, die gerade Rekursion lernen und deshalb mit mir darüber reden können. Weil ich hier direkt aus der Nähe komme, habe ich schon viel vom HPI gehört und finde es toll, was man da so macht. Dieses Design Thinking klingt nach ziemlich viel Spaß. In der Hoffnung, davon auch etwas mitzubekommen, hoffe ich, bei dem Camp genommen zu werden.",
      emergency_number: "01234567891",
      organisation: "Schule am Griebnitzsee",
      vegetarian: false,
      vegan: false,
      allergies: "",
      annotation: "",
      user: user,
      event: event,
      status: ApplicationLetter.statuses[:pending]
  )
end

def application_letter_3(user, event)
  ApplicationLetter.new(
      motivation: "Ich habe schon seit der 8. Klasse das Programmieren als Hobby entdeckt und habe schon eine eigene App im Google Play Store veröffentlicht. Meine anderen Hobbies sind Baseln und Löten, aber Software bauen kann ich von denen am besten. Desshalb will ich gerne mehr darüber lernen. Ich arbeite gerne im Team und freue micht deshalb besonders auf die Zusammenarbeit mit anderen, die auch gerne Programmieren. ",
      emergency_number: "01234567891",
      organisation: "Schule am Griebnitzsee",
      vegetarian: false,
      vegan: true,
      allergies: "",
      annotation: "Euer Angebot find ich echt super.",
      user: user,
      event: event,
      status: ApplicationLetter.statuses[:pending]
  )
end

def application_letter_4(user, event)
  ApplicationLetter.new(
      motivation: "Den normalen Unterricht in der Schule finde ich ziemlich langweilig und würde mich darüber freuen, etwas über den Tellerrand zu schauen und spannende Dinge lernen. Ich arbeite sehr gerne im Team und freue mich darauf, Gleichgesinnte kennen zu lernen.",
      emergency_number: "01234567891",
      organisation: "Schule am Griebnitzsee",
      vegetarian: false,
      vegan: true,
      allergies: "",
      annotation: "Euer Angebot find ich echt super.",
      user: user,
      event: event,
      status: ApplicationLetter.statuses[:pending]
  )
end

def application_letter_5(user, event)
  ApplicationLetter.new(
      motivation: 'Sehr geehrte Damen und Herren,

den normalen Unterricht in der Schule finde ich ziemlich langweilig und würde mich darüber freuen, etwas über den Tellerrand zu schauen und spannende Dinge lernen. Ich arbeite sehr gerne im Team und freue mich darauf, Gleichgesinnte kennen zu lernen.
Ich programmiere seit vielen Jahren mit Java und C++ und würde mich deshalb freuen, diese Fähigkeiten am HPI zu erweitern. Da ich plane, Informatik zu studieren, möchte ich das HPI etwas genauer kennen lernen, um festzustellen, ob es für mich als Studienplatz geeignet ist.  

Viele Grüße
Hendrik',
      emergency_number: "01234567891",
      organisation: "Schule am Griebnitzsee",
      vegetarian: true,
      vegan: false,
      allergies: "Tomaten",
      annotation: "Euer Angebot find ich echt super.",
      user: user,
      event: event,
      status: ApplicationLetter.statuses[:pending]
  )
end

def application_letter_applicant_programmierkurs_1(user, event)
  ApplicationLetter.new(
    motivation: 'Ich würde gerne programmiere lernen, weil man damit total kreativ sein kann. Das klingt nach sehr viel Spaß :)',
    emergency_number: "01234567891",
    organisation: "Schule am Griebnitzsee",
    vegetarian: false,
    vegan: false,
    allergies: "Tomaten",
    annotation: "Euer Angebot find ich echt super.",
    user: user,
    event: event,
    custom_application_fields: ['Dooodlejump', '8', 'Java'],
    status: ApplicationLetter.statuses[:accepted]
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
    status: ApplicationLetter.statuses[:rejected]
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
      status: ApplicationLetter.statuses[:accepted]
  )
end
