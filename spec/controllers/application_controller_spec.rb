require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  context "With a number of events" do
    describe "GET #index" do
      it "selects the first three publicly visible events" do

        event_in_the_future = FactoryGirl.create(:event, :with_two_date_ranges)
        event_today = FactoryGirl.create(:event, :is_only_today)
        event_tomorrow = FactoryGirl.create(:event, :is_only_tomorrow)
        event_past = FactoryGirl.create(:event, :in_the_past_valid)
        
        get :index

        expect(assigns(:events)[0]).to eq(event_today)
        expect(assigns(:events)[1]).to eq(event_tomorrow)
        expect(assigns(:events)[2]).to eq(event_in_the_future)
        expect(assigns(:events).count).to eq 3

      end
    end
  end

end
