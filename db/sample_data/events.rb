def event_programmierkurs
  date_range_singleday = DateRange.create!(
      start_date: Date.new(2017, 05, 04),
      end_date: Date.new(2017, 05, 05)
  )

  Event.new(
      name: 'Android Programmierkurs',
      description: 'Ihr wolltet schon immer einmal eine eigene App programmieren? In diesem Workshop lernt ihr object-orientierte Programmierung am Beispiel von einer Android App.',
      max_participants: 25,
      organizer: 'HPI Schülerklub',
      knowledge_level: 'Anfänger',
      date_ranges: [date_range_singleday],
      application_deadline: Date.tomorrow,
      application_status_locked: false,
      published: true,
      hidden: true,
      custom_application_fields: ['Lieblingsapp']

  )
end

def event_mintcamp
  date_range_mint_camp = DateRange.create!(
      start_date: Date.new(2017, 03, 30),
      end_date: Date.new(2017, 04, 04)
  )

  Event.new(
      name: 'MINT-Camp',
      description: 'Wie soll die digitale Zukunft in den Schulen aussehen? In immer mehr Schulen kommen Smartboards zum Einsatz. Diese elektronischen Tafeln haben das Potenzial den Unterricht und das Lernen nachhaltig zu verbessern. Häufig wird das Gerät allerdings auf seinen älteren Verwandten reduziert und nur zum Schreiben, bestenfalls auch für die Medienwiedergabe genutzt. Der Grund dafür sind meist schwer verständliche Programme, die weder die Bedürfnisse der Schüler noch die der Lehrer erfüllen. Dabei sind weitaus interessantere und vor allem sinnvollere Anwendungen für die intelligenten Tafeln denkbar. In diesem MINT-Camp entwickeln wir in kleinen Teams zunächst mit Hilfe von Design Thinking spannende neuartige Ideen für Smartboards. Anschließend werden die Ideen mit Webtechnologien implementiert und können direkt ausprobiert werden. Zum Abschluss hat jedes Team die Möglichkeit seine fertig entwickelte Anwendung zu präsentieren. Dabei stehen euch die ganze Zeit HPI-Studenten zur Seite und helfen euch bei Problemen aller Art. Vorkenntnisse sind keine erforderlich. ',
      max_participants: 25,
      organizer: 'HPI Schülerklub',
      knowledge_level: 'Fortgeschrittene',
      date_ranges: [date_range_mint_camp],
      application_deadline: Date.tomorrow,
      application_status_locked: false,
      hidden: false,
      published: true

  )
end

def event_bechersaeuberungsevent
  date_range_singleday = DateRange.create!(
      start_date: Date.new(2017, 04, 04),
      end_date: Date.new(2017, 04, 05)
  )
  Event.new(
      name: 'Bechersäuberungsevent',
      description: 'Es dreht sich den ganzen Tag um das Säubern von Bechern. Wie säubert man einen Becher am effizientesten oder am schnellsten? Wie immer bieten wir eine Reihe an Expertenvorträgen an. Dieses Mal erfahrt ihr unter anderem wie ihr Edding-Markierungen selbst nach einer Spülmaschinen-Reinigung noch entfernen könnt oder wie man die richtige Größe für Becher-Stapel herausfindet und anwendet.',
      max_participants: 25,
      organizer: 'FSR',
      knowledge_level: 'Anfänger',
      date_ranges: [date_range_singleday],
      application_deadline: Date.tomorrow,
      application_status_locked: false,
      published: true,
      hidden: false,
      custom_application_fields: ['Lieblings-Becherart', 'Kannst du eine eigene Spülmaschine mitbringen?']

  )
end

def event_gongakrobatik
  date_range_long = DateRange.create!(
      start_date: Date.new(2020, 02, 29),
      end_date: Date.new(2021, 03, 05)
  )
  Event.new(
      name: 'Einführung in die Kunst der Gongakrobatik',
      description: 'Schon im alten China erzählte man sich von den sa­gen­um­wo­benen Legenden der Gongakrobatik. Spätestens seit dieser Trend auch seinen Weg nach Japan gefunden hat, stellt sich die Gongakrobatik auch für uns als ernstzunehmende Alternative gegenüber herkömmlichen Stimmbildungübungen und ähnlichem dar. In dieser Einführung möchten wir euch einen groben Überblick über das Thema geben: Wie findet man am besten seinen Weg in die Gongakrobatik, was braucht man dafür. In den letzten Jahren hat sich zudem eine große Community rund um dieses faszinierende Thema gebildet. Höhepunkt der Veranstaltung ist demnach unser Besuch einer echten Gongmanufaktor im Herzen Berlins, durchgeführt von dem Ding Gong-Verein Berlin. Bei Bedarf können wir eine zweite Veranstaltung durchführen, bis dahin gilt first come first serve :)',
      max_participants: 19,
      knowledge_level: 'Ihr braucht kein besonderes Vorwissen, jeder ist Willkommen!',
      date_ranges: [date_range_long], 
      application_deadline: Date.tomorrow,
      application_status_locked: false,
      hidden: false,
      published: true

  )
end

def event_batterie_akustik
  date_range_short = DateRange.create!(
      start_date: Date.tomorrow.next_day(3),
      end_date: Date.tomorrow.next_day(5)
  )

  date_range_medium = DateRange.create!(
      start_date: Date.new(2017, 06, 01),
      end_date: Date.new(2017, 06, 14)
  )
  Event.new(
      name: 'Batterie-Akustik für Fortgeschrittene',
      description: 'Viele Menschen sammeln bereits im jungen Alter Erfahrung mit der überaus komplexen Batterie-Akustik. "Leider wird daraus bei vielen aber nicht mehr als bloßes Jugendwissen, das sich höchstens für den jährlichen Party-Gag eignet" erklärt Dr. Warta Durazell vom Institut für Angewandte Batterie-Akustik (IAB). Mit dieser Workshop-Serie möchten wir etwas an diesem Missstand ändern. Wie viele Batterien werden benötigt um einen Echo-Effekt gleichwertig zum Akkumulator-Echo zu erzeugen? Ist dies überhaupt außerhalb von Laborbedingungen möglich? Die Teilnehmer haben nach den Veranstaltungen ein fundiertes Wissen über die Klangeigenschaften sowie das (nicht äquivalente) Klangverhalten von Batterien. Zudem erhalten sie ein offizielles Zertifikat des IAB, welches es ihnen ermöglicht an weiterführenden Veranstaltungen zum Thema teilzunehmen. Gerade in Zeit von E-Autos ist dies ein wichtiges Alleinstellungsmerkmal auf dem Arbeitsmarkt. Bitte beachtet die maximale Teilnehmeranzahl! Wichtig: Es gilt first come last served.',
      max_participants: 32,
      organizer: 'IAB',
      date_ranges: [date_range_short, date_range_medium],
      application_deadline: Date.tomorrow,
      application_status_locked: false,
      published: false,
      hidden: false,
      custom_application_fields: ['Spielst du gerne in deiner Freizeit mit Batterien?']
  )
end

def event_bachlorpodium
  date_range_singleday1 = DateRange.create!(
      start_date: Date.tomorrow,
      end_date: Date.tomorrow
  )
  date_range_singleday2 = DateRange.create!(
      start_date: Date.new(2017, 04, 04),
      end_date: Date.new(2017, 04, 05)
  )
  date_range_singleday3 = DateRange.create!(
      start_date: Date.new(2017, 04, 06),
      end_date: Date.new(2017, 04, 06)
  )
  Event.new(
      name: 'Bachelorpodium',
      description: 'Trotz modernem Videostreaming in HD in die anderen Hörsäle bleibt Hörsaal 1 doch der Publikumsliebling bei diesem jährlich mit größter Sorgfalt organisierten spektakulären PR Gag',
      max_participants: 442,
      date_ranges: [date_range_singleday1, date_range_singleday2, date_range_singleday3], 
      application_deadline: Date.tomorrow,
      application_status_locked: false ,
      hidden: true,
      published: true
  )
end
