def email_template_acceptance
  EmailTemplate.new(
    status: :acceptance,
    hide_recipients: true,
    subject: "Zusage",
    content: 'Liebe Bewerberin / lieber Bewerber,

zunächst einmal herzlichen Glückwunsch: **Du bist dabei!** Bitte lies Dir die nachfolgenden Informationen zum Camp aufmerksam durch. Sollte Deine Teilnahme doch nicht möglich sein, bitten wir Dich im Interesse der Schüler auf der Warteliste darum, uns so schnell wie möglich zu informieren.

## Terminliches und Telefonnummern
Die Zeitpunkte für An- und Abreise sowie Telefonnummern für Probleme, z.B. größeren Zugverspätungen am Anreisetag findest Du auf dem Ablaufplan, den wir Dir vor dem Camp zusenden werden.

## Einverständniserklärung
Aus versicherungstechnischen Gründen musst Du, falls Du noch nicht volljährig bist, eine Einverständniserklärung Deiner Eltern hochladen. Die Vorlage dafür findest Du im Anhang dieser E-Mail.

## Wertsachen
Wer Digitalkamera, Laptop, etc. mit zum Camp bringt, ist für deren Sicherheit selbst zuständig. Für Verluste kann das Hasso-Plattner-Institut leider nicht aufkommen.
Weitere Informationen

Aktuelle Information findest Du auch auf der Facebook-Seite des Schülerklubs unter: https://www.facebook.com/hpi.schuelerklub. Zudem haben wir eine Veranstaltung auf Facebook angelegt: https://www.facebook.com/events/846978382011807/. Dort kannst Du Dich mit anderen Teilnehmern über Fahrgemeinschaften austauschen.

Wir wünschen Dir eine schnelle und sichere Anreise. Bei Fragen kannst Du Dich natürlich jederzeit an uns wenden.

Viele Grüße aus Potsdam,
Dein HPI-Workshop-Team

_________________________________________________________
Hasso-Plattner-Institut für Softwaresystemtechnik GmbH
Prof.-Dr.-Helmert-Straße 2-3
14482 Potsdam

www.hpi.de
www.hpi.de/schueler

Folge uns auch auf:
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
      hide_recipients: true,
      subject: "Absage",
      content: 'Liebe Bewerberin / lieber Bewerber,

leider müssen wir Dir mitteilen, dass Du für das Camp nicht zugelassen wurdest.
Versuche es doch bei einem anderen unserer Camps.

Viele Grüße aus Potsdam,
dein HPI-Workshop-Team
_________________________________________________________
Hasso-Plattner-Institut für Softwaresystemtechnik GmbH
Prof.-Dr.-Helmert-Straße 2-3
14482 Potsdam

www.hpi.de
www.hpi.de/schueler

Folge uns auch auf:
www.facebook.com/hpi.schuelerklub
www.facebook.com/HassoPlattnerInstitute
www.twitter.com/HPI_Online
www.youtube.com/hpitv1

Amtsgericht Potsdam, HRB 12184
Geschäftsführung: Prof. Dr. Christoph Meinel

Design IT. Create Knowledge.'
  )
end
