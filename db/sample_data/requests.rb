def request_hardware_entwicklung
  Request.new(
    form_of_address: :mrs,
    first_name: "Martina",
    last_name: "Mustermann",
    phone_number: "0123456789",
    school_street: "Musterstraße 1",
    school_zip_code_city: "12345 Musterstadt",
    email: "mustermann@example.de",
    topic_of_workshop: "Hardware-Entwicklung mit einem CAD-System",
    number_of_participants: 12,
    grade: "8. Klasse",
    status: :open
  )
end
