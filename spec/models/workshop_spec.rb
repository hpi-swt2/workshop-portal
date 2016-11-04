require 'rails_helper'

describe Workshop do

  it "dummy test, add real test" do
    workshop = Workshop.create!(
      name: "best workshop ever"
    )
    expect(workshop.name).to_not be_empty
  end
end
