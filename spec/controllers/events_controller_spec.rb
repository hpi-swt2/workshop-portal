require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe EventsController, type: :controller do
  let(:date1) { Date.today }
  let(:date2) { Date.today.next_day }
  let(:date3) { Date.today.next_day(2) }
  let(:date4) { Date.today.next_day(2) }

  # this is the format expected by our controller due to reasons outlined
  # in EventsController#date_range_params
  let(:valid_attributes_post) {
    {
        event: {
          name: 'Test',
          description: 'Test',
          max_participants: 1,
          active: false,
        },
        date_ranges: {
          start_date: [
            {day: date1.day, month: date1.month, year: date1.year},
            {day: date3.day, month: date3.month, year: date3.year}
          ],
          end_date: [
            {day: date2.day, month: date2.month, year: date2.year},
            {day: date4.day, month: date4.month, year: date4.year}
          ]
        }
      }
  }

  # This should return the minimal set of attributes required to create a valid
  # Event. As you add validations to Event, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for(:event) }

  let(:invalid_attributes) { FactoryGirl.attributes_for(:event, max_participants: "twelve") }

  let(:valid_attributes_for_having_participants) { FactoryGirl.attributes_for(:event_with_accepted_applications) }
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EventsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all events as @events" do
      event = Event.create! valid_attributes
      get :index, session: valid_session
      expect(assigns(:events)).to eq([event])
    end
  end

  describe "GET #show" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :show, id: event.to_param, session: valid_session
      expect(assigns(:event)).to eq(event)
    end

    it "assigns the number of free places as @free_places" do
      event = Event.create! valid_attributes
      get :show, id: event.to_param, session: valid_session
      expect(assigns(:free_places)).to eq(event.compute_free_places)
    end

    it "assigns the number of occupied places as @occupied_places" do
      event = Event.create! valid_attributes
      get :show, id: event.to_param, session: valid_session
      expect(assigns(:occupied_places)).to eq(event.compute_occupied_places)
    end
  end

  describe "GET #new" do
    it "assigns a new event as @event" do
      get :new, params: {}, session: valid_session
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe "GET #edit" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :edit, id: event.to_param, session: valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, valid_attributes_post, session: valid_session
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, valid_attributes_post, session: valid_session
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it "saves optional attributes" do
        post :create, event: valid_attributes, session: valid_session
        event = Event.create! valid_attributes
        expect(assigns(:event).organizer).to eq(event.organizer)
        expect(assigns(:event).knowledge_level).to eq(event.knowledge_level)
      end

      it "redirects to the created event" do
        post :create, valid_attributes_post, session: valid_session
        expect(response).to redirect_to(Event.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, event: invalid_attributes, session: valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, event: invalid_attributes, session: valid_session
        expect(response).to render_template("new")
      end
    end

    it "should attach correct date ranges to the event entity" do
      post :create, valid_attributes_post, session: valid_session
      expect(assigns(:event)).to be_a(Event)
      expect(assigns(:event)).to be_persisted
      expect(assigns(:event).date_ranges).to_not be_empty
      expect(assigns(:event).date_ranges.first.event_id).to eq(assigns(:event).id)
      expect(assigns(:event).date_ranges.first.start_date).to eq(date1)
      expect(assigns(:event).date_ranges.first.end_date).to eq(date2)
      expect(assigns(:event).date_ranges.second.start_date).to eq(date3)
      expect(assigns(:event).date_ranges.second.end_date).to eq(date4)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
            name: "Awesome new name"
        }
      }

      it "updates the requested event" do
        event = Event.create! valid_attributes
        put :update, id: event.to_param, event: new_attributes, session: valid_session
        event.reload
        expect(event.name).to eq(new_attributes[:name])
      end

      it "assigns the requested event as @event" do
        event = Event.create! valid_attributes
        put :update, id: event.to_param, event: valid_attributes, session: valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "redirects to the event" do
        event = Event.create! valid_attributes
        put :update, id: event.to_param, event: valid_attributes, session: valid_session
        expect(response).to redirect_to(event)
      end
    end

    context "with invalid params" do
      it "assigns the event as @event" do
        event = Event.create! valid_attributes
        put :update, id: event.to_param, event: invalid_attributes, session: valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "re-renders the 'edit' template" do
        event = Event.create! valid_attributes
        put :update, id: event.to_param, event: invalid_attributes, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, id: event.to_param, session: valid_session
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      event = Event.create! valid_attributes
      delete :destroy, id: event.to_param, session: valid_session
      expect(response).to redirect_to(events_url)
    end
  end

  describe "GET #participants" do
  
    it "assigns the event as @event" do
      event = Event.create! valid_attributes_for_having_participants
      get :participants, id: event.to_param, session: valid_session
      expect(assigns(:event)).to eq(event)
    end
	it "assigns all participants as @participants" do
	  event = Event.create! valid_attributes_for_having_participants
      get :participants, id: event.to_param, session: valid_session
	  expect(assigns(:participants)).to eq(event.participants)
	end
  end
end
