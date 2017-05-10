def email_template_acceptance
  EmailTemplate.new(
    status: :acceptance,
    hide_recipients: false,
    subject: "Zusage für TODO",
    content: 'Liebe Camp-Teilnehmerinnen und -Teilnehmer,

zunächst einmal herzlichen Glückwunsch: **Du bist dabei!** Bitte lies Dir die nachfolgenden Informationen zum TODO, das vom TODO bis TODO stattfinden wird, aufmerksam durch. Sollte deine Teilnahme doch nicht möglich sein, bitten wir dich im Interesse der Schüler auf der Warteliste darum, uns so schnell wie möglich zu informieren.
Terminliches und Telefonnummern
Die Zeitpunkte für An- und Abreise sowie Telefonnummern für Probleme, z.B. größeren Zugverspätungen am Anreisetag findest Du auf dem angehängten Ablaufplan.

## Einverständniserklärung
Aus versicherungstechnischen Gründen musst Du, falls Du noch nicht volljährig bist, eine Einverständniserklärung deiner Eltern hochladen.

## Wertsachen
Wer Digitalkamera, Laptop, etc. mit zum Camp bringt, ist für deren Sicherheit selbst zuständig. Für Verluste kann das Hasso-Plattner-Institut leider nicht aufkommen.
Weitere Informationen
Weitere Informationen werden nächste Woche direkt vom MINT-EC per Mail an euch versandt.

Aktuelle Information findest Du auch auf der Facebook-Seite des Schülerklubs unter: https://www.facebook.com/hpi.schuelerklub. Zudem hat der MINT-EC eine Veranstaltung auf Facebook angelegt: https://www.facebook.com/events/846978382011807/

Wir wünschen Dir eine schnelle und sichere Anreise. Bei Fragen kannst Du dich natürlich jederzeit an uns wenden.

Viele Grüße aus Potsdam,
dein HPI-Workshop-Team
------------------------------------------------------------------------------
Hasso-Plattner-Institut für Softwaresystemtechnik GmbH
Prof.-Dr.-Helmert-Straße 2-3
14482 Potsdam

www.hpi.de
www.hpi.de/schueler

Folgen Sie uns auch auf:
www.facebook.com/hpi.schuelerklub
www.facebook.com/HassoPlattnerInstitute
www.twitter.com/HPI_Online
www.youtube.com/hpitv1

Amtsgericht Potsdam, HRB 12184
Geschäftsführung: Prof. Dr. Christoph Meinel

Design IT. Create Knowledge.'
  )
end

def email_template_rejection
  EmailTemplate.new(
      status: :rejection,
      hide_recipients: false,
      subject: "Absage für TODO",
      content: 'Liebe Bewerberin / lieber Bewerber,

leider müssen wir Dir mitteilen, dass Du für TODO nicht zugelassen wurdest.
Versuche es doch bei einem anderen unserer Camps.

Viele Grüße aus Potsdam,
dein HPI-Workshop-Team
------------------------------------------------------------------------------
Hasso-Plattner-Institut für Softwaresystemtechnik GmbH
Prof.-Dr.-Helmert-Straße 2-3
14482 Potsdam

www.hpi.de
www.hpi.de/schueler

Folgen Sie uns auch auf:
www.facebook.com/hpi.schuelerklub
www.facebook.com/HassoPlattnerInstitute
www.twitter.com/HPI_Online
www.youtube.com/hpitv1

Amtsgericht Potsdam, HRB 12184
Geschäftsführung: Prof. Dr. Christoph Meinel

Design IT. Create Knowledge.'
  )
end
