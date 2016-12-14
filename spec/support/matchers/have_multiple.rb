RSpec::Matchers.define :have_every_text do |collection|
  match do
    collection.each do |element|
      expect(page).to have_text(element)
    end
  end
end

RSpec::Matchers.define :have_no_text do |collection|
  match do
    collection.each do |element|
      expect(page).to_not have_text(element)
    end
  end
end
