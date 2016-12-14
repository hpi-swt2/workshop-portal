def agreement_letter_applicant_gongakrobatik(user, event)
  AgreementLetter.new(
    user: user,
    event: event,
    path: "/storage/agreement_letters/foo.pdf"
  )
end