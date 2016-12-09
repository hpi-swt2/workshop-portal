def add_sample_data
  events = Hash.new
  events[:bechersaeuberungsevent] = event_bechersaeuberungsevent
  events[:gongakrobatik] = event_gongakrobatik
  events[:batterie_akustik] = event_batterie_akustik
  events[:bachlorpodium] = event_bachlorpodium

  users = Hash.new
  users[:pupil] = user_pupil
  users[:teacher] = user_teacher
  users[:applicant] = user_applicant

  profiles = Hash.new
  profiles[:pupil] = profile_pupil(users[:pupil])
  profiles[:teacher] = profile_teacher(users[:teacher])
  profiles[:applicant] = profile_applicant(users[:applicant])

  application_letters = Hash.new
  application_letters[:applicant_gongakrobatik] = application_letter_applicant_gongakrobatik(users[:applicant], events[:gongakrobatik])

  requests = Hash.new
  requests[:hardware_entwicklung] = request_hardware_entwicklung(users[:teacher])

  agreement_letters = Hash.new
  agreement_letters[:applicant_gongakrobatik] = agreement_letter_applicant_gongakrobatik(users[:applicant], events[:gongakrobatik])

  [events, users, profiles, application_letters, requests, agreement_letters].each do |models|
    save_models(models)
  end
end

private
  def save_models(models)
    models.each do |key, model|
      model.save!
    end
  end

  def event_bechersaeuberungsevent
    date_range_singleday = DateRange.find_or_create_by!(
        start_date: Date.new(2017, 04, 04),
        end_date: Date.new(2017, 04, 05)
    )
    Event.new(
        name: 'Bechersäuberungsevent',
        description: 'Es dreht sich den ganzen Tag um das Säubern von Bechern. Wie säubert man einen Becher am
  effizientesten oder am schnellsten? Wie immer bieten wir eine Reihe an Expertenvorträgen an. Dieses Mal erfahrt ihr
  unter anderem wie ihr Edding-Markierungen selbst nach einer Spülmaschinen-Reinigung noch entfernen könnt oder wie man
  die richtige Größe für Becher-Stapel herausfindet und anwendet.',
        max_participants: 25,
        active: true,
        organizer: 'FSR',
        knowledge_level: 'Anfänger',
        date_ranges: [date_range_singleday]
    )
  end

  def event_gongakrobatik
    date_range_long = DateRange.find_or_create_by!(
        start_date: Date.new(2020, 02, 29),
        end_date: Date.new(2021, 03, 05)
    )
    Event.new(
        name: 'Einführung in die Kunst der Gongakrobatik',
        description: 'Schon im alten China erzählte man sich von den sa­gen­um­wo­benen Legenden der Gongakrobatik.
  Spätestens seit dieser Trend auch seinen Weg nach Japan gefunden hat, stellt sich die Gongakrobatik auch für uns als
  ernstzunehmende Alternative gegenüber herkömmlichen Stimmbildungübungen und ähnlichem dar. In dieser Einführung möchten
  wir euch einen groben Überblick über das Thema geben: Wie findet man am besten seinen Weg in die Gongakrobatik, was
  braucht man dafür. In den letzten Jahren hat sich zudem eine große Community rund um dieses faszinierende Thema gebildet.
  Höhepunkt der Veranstaltung ist demnach unser Besuch einer echten Gongmanufaktor im Herzen Berlins, durchgeführt von dem
  Ding Gong-Verein Berlin. Bei Bedarf können wir eine zweite Veranstaltung durchführen, bis dahin gilt first come first serve :)',
        max_participants: 19,
        active: true,
        knowledge_level: 'Ihr braucht kein besonderes Vorwissen, jeder ist Willkommen!',
        date_ranges: [date_range_long]
    )
  end

  def event_batterie_akustik
    date_range_short = DateRange.find_or_create_by!(
        start_date: Date.today,
        end_date: Date.tomorrow
    )

    date_range_medium = DateRange.find_or_create_by!(
        start_date: Date.new(2017, 06, 01),
        end_date: Date.new(2017, 06, 14)
    )
    Event.new(
        name: 'Batterie-Akustik für Fortgeschrittene',
        description: 'Viele Menschen sammeln bereits im jungen Alter Erfahrung mit der überaus komplexen Batterie-Akustik.
  "Leider wird daraus bei vielen aber nicht mehr als bloßes Jugendwissen, das sich höchstens für den jährlichen Party-Gag
  eignet" erklärt Dr. Warta Durazell vom Institut für Angewandte Batterie-Akustik (IAB). Mit dieser Workshop-Serie möchten
  wir etwas an diesem Missstand ändern. Wie viele Batterien werden benötigt um einen Echo-Effekt gleichwertig zum
  Akkumulator-Echo zu erzeugen? Ist dies überhaupt außerhalb von Laborbedingungen möglich? Die Teilnehmer haben nach den
  Veranstaltungen ein fundiertes Wissen über die Klangeigenschaften sowie das (nicht äquivalente) Klangverhalten von
  Batterien. Zudem erhalten sie ein offizielles Zertifikat des IAB, welches es ihnen ermöglicht an weiterführenden
  Veranstaltungen zum Thema teilzunehmen. Gerade in Zeit von E-Autos ist dies ein wichtiges Alleinstellungsmerkmal auf dem
  Arbeitsmarkt. Bitte beachtet die maximale Teilnehmeranzahl! Wichtig: Es gilt first come last served.',
        max_participants: 32,
        active: true,
        organizer: 'IAB',
        date_ranges: [date_range_short, date_range_medium]
    )
  end

  def event_bachlorpodium
    date_range_singleday1 = DateRange.find_or_create_by!(
        start_date: Date.tomorrow,
        end_date: Date.tomorrow
    )
    date_range_singleday2 = DateRange.find_or_create_by!(
        start_date: Date.new(2017, 04, 04),
        end_date: Date.new(2017, 04, 05)
    )
    date_range_singleday3 = DateRange.find_or_create_by!(
        start_date: Date.new(2017, 04, 06),
        end_date: Date.new(2017, 04, 06)
    )
    Event.new(
        name: 'Bachelorpodium',
        description: 'Trotz modernem Videostreaming in HD in die anderen Hörsäle bleibt Hörsaal 1 doch der Publikumsliebling
  bei diesem jährlich mit größter Sorgfalt organisierten spektakulären PR Gag',
        max_participants: 442,
        active: true,
        date_ranges: [date_range_singleday1, date_range_singleday2, date_range_singleday3]
    )
  end

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

  def profile_pupil(user)
    Profile.new(
      user: user,
      first_name: "Karl",
      last_name: "Doe",
      gender: "männlich",
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
      gender: "männlich",
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
      gender: "weiblich",
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

  def request_hardware_entwicklung(user)
    Request.new(
      topics: "Hardware-Entwicklung mit einem CAD-System",
      user: user
    )
  end

  def agreement_letter_applicant_gongakrobatik(user, event)
    AgreementLetter.new(
      user: user,
      event: event,
      path: "/storage/agreement_letters/foo.pdf"
    )
  end
