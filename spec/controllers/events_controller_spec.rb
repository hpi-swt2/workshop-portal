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
  let(:date1) { Date.current }
  let(:date2) { Date.current.next_day }
  let(:date3) { Date.current.next_day(2) }
  let(:date4) { Date.current.next_day(2) }

  # this is the format expected by our controller to receive its date ranges
  # in as a nested object
  let(:valid_attributes_post) do
    event = FactoryGirl.attributes_for(:event)
    event[:date_ranges_attributes] = [FactoryGirl.attributes_for(:date_range)]
    { event: event }
  end

  # This should return the minimal set of attributes required to create a valid
  # Event. As you add validations to Event, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for(:event) }

  let(:invalid_attributes) { FactoryGirl.attributes_for(:event, max_participants: "twelve") }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EventsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context "With an existing event" do
    before :each do
      @event = Event.create! valid_attributes
    end

    describe "GET #index" do
      it "assigns all events as @events" do
        get :index, session: valid_session
        expect(assigns(:events)).to eq([@event])
      end
    end

    describe "GET #show" do
      it "assigns the requested event as @event" do
        get :show, id: @event.to_param, session: valid_session
        expect(assigns(:event)).to eq(@event)
      end

      it "assigns the number of free places as @free_places" do
        get :show, id: @event.to_param, session: valid_session
        expect(assigns(:free_places)).to eq(@event.compute_free_places)
      end

      it "assigns the number of occupied places as @occupied_places" do
        get :show, id: @event.to_param, session: valid_session
        expect(assigns(:occupied_places)).to eq(@event.compute_occupied_places)
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
        get :edit, id: @event.to_param, session: valid_session
        expect(assigns(:event)).to eq(@event)
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
          put :update, id: @event.to_param, event: new_attributes, session: valid_session
          @event.reload
          expect(@event.name).to eq(new_attributes[:name])
        end

        it "assigns the requested event as @event" do
          put :update, id: @event.to_param, event: valid_attributes, session: valid_session
          expect(assigns(:event)).to eq(@event)
        end

        it "redirects to the event" do
          put :update, id: @event.to_param, event: valid_attributes, session: valid_session
          expect(response).to redirect_to(@event)
        end

        it "does not append to date ranges but replaces them" do
          expect {
            put :update, id: @event.to_param, event: valid_attributes_post[:event], session: valid_session
          }.to change((Event.find_by! id: @event.to_param).date_ranges, :count).by(0)
        end
      end

      context "with invalid params" do
        it "assigns the event as @event" do
          put :update, id: @event.to_param, event: invalid_attributes, session: valid_session
          expect(assigns(:event)).to eq(@event)
        end

        it "re-renders the 'edit' template" do
          put :update, id: @event.to_param, event: invalid_attributes, session: valid_session
          expect(response).to render_template("edit")
        end
      end

      describe "DELETE #destroy" do
        it "destroys the requested event" do
          expect {
            delete :destroy, id: @event.to_param, session: valid_session
          }.to change(Event, :count).by(-1)
        end

        it "redirects to the events list" do
          delete :destroy, id: @event.to_param, session: valid_session
          expect(response).to redirect_to(events_url)
        end
      end

      describe "GET #participants" do
        let(:valid_attributes) { FactoryGirl.attributes_for(:event_with_accepted_applications) }

        it "assigns the event as @event" do
          get :participants, id: @event.to_param, session: valid_session
          expect(assigns(:event)).to eq(@event)
        end
        it "assigns all participants as @participants" do
          get :participants, id: @event.to_param, session: valid_session
          expect(assigns(:participants)).to eq(@event.participants)
        end
      end
    end

    describe "GET #accept_all_applicants" do
      it "should redirect to the event" do
        get :accept_all_applicants, id: @event.to_param, session: valid_session
        expect(response).to redirect_to(@event)
      end
    end
  end

  describe "GET #participants_pdf" do
    let(:valid_attributes) { FactoryGirl.attributes_for(:event_with_accepted_applications) }

    it "should return an pdf" do
      event = Event.create! valid_attributes
      get :participants_pdf, id: event.to_param, session: valid_session
      expect(response.content_type).to eq('application/pdf')
    end

    it "should return an pdf with the name of the user" do
      event = Event.create! valid_attributes
      profile = FactoryGirl.create(:profile)
      user = FactoryGirl.create(:user, profile: profile)
      application_letter = FactoryGirl.create(:application_letter, status: ApplicationLetter.statuses[:accepted], event: event, user: user)
      response = get :participants_pdf, id: event.to_param, session: valid_session
      expect(response.content_type).to eq('application/pdf')

      pdf = PDF::Inspector::Text.analyze(response.body)
      expect(pdf.strings).to include("Vorname")
      expect(pdf.strings).to include("Nachname")
      expect(pdf.strings).to include(application_letter.user.profile.first_name)
    end
  end

  describe "GET #print_applications_eating_habits" do
    
    let(:valid_attributes) { FactoryGirl.attributes_for(:event_with_accepted_applications) }

    it "should return an pdf" do
      login(:organizer)
      event = Event.create! valid_attributes
      profile = FactoryGirl.create(:profile)
      user = FactoryGirl.create(:user, profile: profile)
      application_letter = FactoryGirl.create(:application_letter, status: ApplicationLetter.statuses[:accepted], event: event, user: user)
      get :print_applications_eating_habits, id: event.to_param, session: valid_session
      target = event_path(event) + "/print_applications_eating_habits"
      expect(response.content_type).to eq('application/pdf')
    end

    it "should return an pdf with the eating habits of the user" do
      login(:organizer)
      event = Event.create! valid_attributes
      
      user = FactoryGirl.create(:user)
      profile = FactoryGirl.create(:profile, user: user, last_name: "Peter")
      application_letter = FactoryGirl.create(:application_letter_accepted, 
        user: user, event: event, vegan: true)
      user = FactoryGirl.create(:user)
      profile = FactoryGirl.create(:profile, user: user, last_name: "Paul")
      application_letter = FactoryGirl.create(:application_letter_accepted, 
        user: user, event: event, vegan: true, allergic: true)
      user = FactoryGirl.create(:user)
      profile = FactoryGirl.create(:profile, user: user, last_name: "Mary")
      application_letter = FactoryGirl.create(:application_letter_accepted, 
        user: user, event: event, vegetarian: true)
      user = FactoryGirl.create(:user)
      profile = FactoryGirl.create(:profile, user: user, last_name: "Otti")
      application_letter = FactoryGirl.create(:application_letter_accepted, 
        user: user, event: event, vegetarian: true, allergic: true)
      user = FactoryGirl.create(:user)
      profile = FactoryGirl.create(:profile, user: user, last_name: "Benno")
      application_letter = FactoryGirl.create(:application_letter_accepted, 
        user: user, event: event)

      response = get :print_applications_eating_habits, id: event.to_param, session: valid_session
      expect(response.content_type).to eq('application/pdf')

      pdf = PDF::Inspector::Text.analyze(response.body)
    
      expect(pdf.strings).to include(I18n.t("events.participants.print_title", title: event.name))
      expect(pdf.strings).to include(I18n.t("events.participants.print_summary", number: 5))
      expect(pdf.strings).to include(I18n.t("events.participants.print_summary_vegan", number: 2))
      expect(pdf.strings).to include(I18n.t("events.participants.print_summary_vegetarian", number: 2))
      expect(pdf.strings).to include(I18n.t("events.participants.print_summary_allergic", number: 2))
    end
  end

  describe "GET #badges" do
    let(:valid_attributes) { FactoryGirl.attributes_for(:event_with_accepted_applications) }

    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :badges, event_id: event.to_param, session: valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe "POST #badges" do
    it "contains two name badges with title 'Max Mustermann'" do
      event = Event.create! valid_attributes
      rendered_pdf = post :print_badges,
                          event_id: event.to_param,
                          session: valid_session,
                          "1234_print"  => "Max Mustermann",
                          "1235_print"  => "Max Mustermann",
                          "1236_print"  => "Max Mustermann",
                          "1237_print"  => "Max Mustermann",
                          "1238_print"  => "Max Mustermann",
                          "1239_print"  => "Max Mustermann",
                          "1240_print"  => "John Doe",
                          "1241_print"  => "Max Mustermann",
                          "1242_print"  => "Max Mustermann",
                          "1243_print"  => "Max Mustermann",
                          "1244_print"  => "Max Mustermann",
                          "1245_print"  => "Max Mustermann"

      pdf = PDF::Inspector::Text.analyze(rendered_pdf.body)
      expect(pdf.strings).to include("Max Mustermann")
      expect(pdf.strings).to include("John Doe")
    end
  end

  describe "POST #upload_material" do
    before :each do
      filepath = Rails.root.join('spec/testfiles/actual.pdf')
      @file = fixture_file_upload(filepath, 'application/pdf')
      @event = Event.create! valid_attributes
    end

    after :each do
      filepath = File.join(@event.material_path, @file.original_filename)
      File.delete(filepath) if File.exist?(filepath)
    end

    it "uploads a file to the event's material directory" do
      post :upload_material, event_id: @event.to_param, session: valid_session, file_upload: @file
      expect(response).to redirect_to :action => :show, :id => @event.id
      expect(File.exists?(File.join(@event.material_path, @file.original_filename)))
      expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
    end

    it "shows error if no file was given" do
      post :upload_material, event_id: @event.to_param, session: valid_session
      expect(response).to redirect_to :action => :show, :id => @event.id
      expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
    end

    it "shows error if file saving was not successfull" do
      allow(File).to receive(:write).and_raise(IOError)
      post :upload_material, event_id: @event.to_param, session: valid_session, file_upload: @file
      expect(response).to redirect_to :action => :show, :id => @event.id
      expect(flash[:alert]).to match(I18n.t(:saving_fails, scope: 'events.material_area'))
    end
  end

  describe "POST #download_material" do
    before :each do
      @user = FactoryGirl.create(:user, role: :coach)
      @user.profile ||= FactoryGirl.create(:profile)
      sign_in @user

      filepath = Rails.root.join('spec/testfiles/actual.pdf')
      @file = fixture_file_upload(filepath, 'application/pdf')
      @event = Event.create! valid_attributes
      post :upload_material, event_id: @event.to_param, session: valid_session, file_upload: @file
    end

    after :each do
      filepath = File.join(@event.material_path, @file.original_filename)
      File.delete(filepath) if File.exist?(filepath)
    end

    it "download a file from the event's material directory" do
      post :download_material, event_id: @event.to_param, session: valid_session, file: @file.original_filename
      expect(response.header['Content-Type']).to match('application/pdf')
    end

    it "shows error if no file was given" do
      post :download_material, event_id: @event.to_param, session: valid_session
      expect(response).to redirect_to :action => :show, :id => @event.id
      expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
    end

    it "shows error if file was not found in event's material directory" do
      post :download_material, event_id: @event.to_param, session: valid_session, file: "dump.pdf"
      expect(response).to redirect_to :action => :show, :id => @event.id
      expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
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
        post :create, valid_attributes_post, session: valid_session
        event = Event.create! valid_attributes
        expect(assigns(:event).organizer).to eq(event.organizer)
        expect(assigns(:event).knowledge_level).to eq(event.knowledge_level)
        expect(assigns(:event).custom_application_fields).to eq(event.custom_application_fields)
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
      date_range = valid_attributes_post[:event][:date_ranges].first
      expect(assigns(:event).date_ranges.first.start_date).to eq(date_range.start_date)
      expect(assigns(:event).date_ranges.first.end_date).to eq(date_range.end_date)
    end
  end

  describe "GET #print_applications" do
    before :each do
      @event = Event.create! valid_attributes
      @user = FactoryGirl.create(:user, role: :organizer)
      sign_in @user
    end

    it "returns success" do
      get :print_applications, id: @event.to_param, session: valid_session
      expect(response).to be_success
    end

    it 'returns downloadable PDF' do
      get :print_applications, id: @event.to_param, session: valid_session
      PDF::Inspector::Text.analyze response.body
    end

    it "returns a PDF with a correct overview page" do
      get :print_applications, id: @event.to_param, session: valid_session
      page_analysis = PDF::Inspector::Page.analyze(response.body)
      expect(page_analysis.pages.size).to be 1
      analysis = PDF::Inspector::Text.analyze response.body
      text = analysis.strings.join
      expect(text).to include(
        @event.name,
        @event.max_participants.to_s,
        @event.organizer,
        @event.knowledge_level,
        @event.compute_free_places.to_s,
        @event.compute_occupied_places.to_s)
      @event.date_ranges.each { |d| expect(text).to include(d.to_s) }
    end

    it "shows an overview of all and details of every application" do
      al = FactoryGirl.create(:application_letter, event: @event,)
      FactoryGirl.create(:application_note, application_letter_id: al.id)
      User.find_each { |u| FactoryGirl.create(:profile, user: u) }
      get :print_applications, id: @event.to_param, session: valid_session
      analysis = PDF::Inspector::Text.analyze response.body
      text = analysis.strings.join(' ')
      @event.application_letters.each do |a|
        expect(text).to include(
          a.user.profile.name,
          a.user.profile.age_at_time(@event.start_date).to_s,
          I18n.t("profiles.genders.#{a.user.profile.gender}"),
          a.user.accepted_applications_count(@event).to_s,
          a.user.rejected_applications_count(@event).to_s,
          I18n.t("application_status.#{a.status}"),
          a.motivation
        )
        a.application_notes.each do |note|
          expect(text).to include(note.note)
        end
      end
    end

    it "includes at last one page per application" do
      FactoryGirl.create(:application_letter, event: @event,)
      FactoryGirl.create(:application_letter2, event: @event,)
      User.find_each { |u| FactoryGirl.create(:profile, user: u) }
      get :print_applications, id: @event.to_param, session: valid_session
      page_analysis = PDF::Inspector::Page.analyze(response.body)
      expect(page_analysis.pages.size).to be >= 3
    end

    it "extends long applications over several pages" do
      FactoryGirl.create(:application_letter_long, event: @event,)
      User.find_each { |u| FactoryGirl.create(:profile, user: u) }
      get :print_applications, id: @event.to_param, session: valid_session
      page_analysis = PDF::Inspector::Page.analyze(response.body)
      expect(page_analysis.pages.size).to be >= 3
    end
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    sign_in(@profile.user, :scope => :user)
  end
end
