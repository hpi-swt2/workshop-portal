require 'rails_helper'

describe Application do

  it "dummy test, add real one" do
    application = Application.create!(
                                 workshop: FactoryGirl.create(:workshop),
                                 user: FactoryGirl.create(:user)
    )
    motivation = "This is the motivation"
    application.motivation = motivation
    expect(application.motivation).to eq(motivation)
  end
end
