require 'rails_helper'

describe Request do

  it "dummy test, add real one" do
    request = Request.create!(
                         user: FactoryGirl.create(:user)
    )
    expect(request).to_not be_nil
  end
end
