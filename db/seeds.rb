if Workshop.where(name: "Our first Workshop").empty?
  Workshop.create!(
              name: "Our first Workshop",
              description: "The first workshop, we created",
              max_participants: 20,
              active: true
  )
end

if User.where(email: "marko@mustermann.de").empty?
  Profile.create!(
      cv: "A very impressive CV",
      user: User.create!(
          name: "Marko Mustermann",
          email: "marko@mustermann.de",
          password: "test12345"
      )
  )
end

if Request.where(topics: "Ruby on Rails Programming").empty?
  Request.create!(
      topics: "Ruby on Rails Programming",
      user: User.create!(
          name: "Mario Mustermann",
          email: "mario@mustermann.de",
          password: "test12345"
      )
  )
  Profile.create!(
      cv: "I have started with Rails and like to improve my knowledge in workshops.",
      user: User.find_by_email("mario@mustermann.de")
  )
end

if ApplicationLetter.where(motivation: "I would really like to take part at the first workshop.").empty?
  ApplicationLetter.create!(
      motivation: "I would really like to take part at the first workshop.",
      user: User.create!(
          name: "Mirko Mustermann",
          email: "mirko@mustermann.de",
          password: "test12345"
      ),
      workshop: Workshop.find_by_name("Our first Workshop")
  )
  Profile.create!(
      cv: "No experience with workshops yet, so let me join.",
      user: User.find_by_email("mirko@mustermann.de")
  )
end