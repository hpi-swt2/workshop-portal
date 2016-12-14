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
      organizer: 'FSR',
      knowledge_level: 'Anfänger',
      date_ranges: [date_range_singleday], 
      application_deadline: Date.tomorrow,
      draft: false, 
      application_status_locked: false
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
      knowledge_level: 'Ihr braucht kein besonderes Vorwissen, jeder ist Willkommen!',
      date_ranges: [date_range_long], 
      application_deadline: Date.tomorrow, 
      draft: false, 
      application_status_locked: false
  )
end

def event_batterie_akustik
  date_range_short = DateRange.find_or_create_by!(
      start_date: Date.tomorrow.next_day(3),
      end_date: tomorrow.next_day(5)
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
      organizer: 'IAB',
      date_ranges: [date_range_short, date_range_medium],  
      application_deadline: Date.tomorrow,
      draft: false, 
      application_status_locked: false 
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
      date_ranges: [date_range_singleday1, date_range_singleday2, date_range_singleday3], 
      application_deadline: Date.tomorrow, 
      draft: false, 
      application_status_locked: false 
  )
end