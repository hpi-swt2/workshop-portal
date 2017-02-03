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

RSpec.describe RequestsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:request) }

  let(:invalid_attributes) { FactoryGirl.build(:request, form_of_address: nil).attributes }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RequestsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context "with an existing request" do
    before :each do
      # Cannot use @request, because this variable is already in use.
      @a_request = Request.create! valid_attributes
      sign_in FactoryGirl.create(:user, role: :organizer)
    end

    describe "GET #show" do
      it "assigns the requested request as @request" do
        get :show, id: @a_request.to_param, session: valid_session
        expect(assigns(:request)).to eq(@a_request)
      end
    end

    describe "GET #new" do
      it "assigns a new request as @request" do
        get :new, session: valid_session
        expect(assigns(:request)).to be_a_new(Request)
      end
    end

    describe "GET #edit" do
      it "assigns the requested request as @request" do
        get :edit, id: @a_request.to_param, session: valid_session
        expect(assigns(:request)).to eq(@a_request)
      end
    end

    describe "GET #accept" do
      it "rejects the request for normal users" do
        get :accept, id: @a_request.to_param, session: valid_session
        expect(@a_request.status.to_sym).to eq(:open)
      end
    end


    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {
              topic_of_workshop: "New awesome topics"
          }
        }

        it "updates the requested request" do
          put :update, id: @a_request.to_param, request: new_attributes, session: valid_session
          @a_request.reload
          expect(@a_request.topic_of_workshop).to eq(new_attributes[:topic_of_workshop])
        end

        it "assigns the requested request as @request" do
          put :update, id: @a_request.to_param, request: valid_attributes, session: valid_session
          expect(assigns(:request)).to eq(@a_request)
        end

        it "redirects to the request" do
          put :update, id: @a_request.to_param, request: valid_attributes, session: valid_session
          expect(response).to redirect_to(@a_request)
        end
      end

      context "with invalid params" do
        it "assigns the request as @request" do
          put :update, id: @a_request.to_param, request: invalid_attributes, session: valid_session
          expect(assigns(:request)).to eq(@a_request)
        end

        it "re-renders the 'edit' template" do
          put :update, id: @a_request.to_param, request: invalid_attributes, session: valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested request" do
        Request.create! valid_attributes
        expect {
          delete :destroy, id: @a_request.to_param, session: valid_session
        }.to change(Request, :count).by(-1)
      end

      it "redirects to the requests list" do
        Request.create! valid_attributes
        delete :destroy, id: @a_request.to_param, session: valid_session
        expect(response).to redirect_to(requests_url)
      end
    end
  end

  context "as user without login" do
    before :each do
      @a_request = Request.create! valid_attributes
    end

    it "redirects to home when updating" do
      put :update, id: @a_request.to_param, request: valid_attributes, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it "redirects to home when showing" do
      get :show, id: @a_request.to_param, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it "redirects to home when deleting" do
      delete :destroy, id: @a_request.to_param, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    it "redirects to home when viewing the index page" do
      get :index, session: valid_session
      expect(response).to redirect_to(root_path)
    end
  end

  ['contact_person', 'notes'].each do |field|
    describe "PATCH #set_#{field}" do
      path = "set_#{field}"

      before :each do
        @a_request = Request.create! valid_attributes
        sign_in FactoryGirl.create(:user, role: :organizer)
      end

      context "with valid params" do
        it "saves the #{field}" do
          value = 'New Value'
          data = {}
          data[field] = value
          patch path, request_id: @a_request.to_param, request: data, session: valid_session
          @a_request.reload
          expect(@a_request.send(field)).to eq(value)
        end
      end

      context "with invalid params" do
        it "re-renders the 'show' template" do
          patch path, request_id: @a_request.to_param, request: invalid_attributes, session: valid_session
          expect(response).to render_template("show")
        end
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Request" do
        expect {
          post :create, request: valid_attributes, session: valid_session
        }.to change(Request, :count).by(1)
      end

      it "assigns a newly created request as @request" do
        post :create, request: valid_attributes, session: valid_session
        expect(assigns(:request)).to be_a(Request)
        expect(assigns(:request)).to be_persisted
      end

      it "sends an email" do
        expect{ post :create, request: valid_attributes, session: valid_session }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end

      it "redirects to the homepage" do
        post :create, request: valid_attributes, session: valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved request as @request" do
        post :create, request: invalid_attributes, session: valid_session
        expect(assigns(:request)).to be_a_new(Request)
      end

      it "re-renders the 'new' template" do
        post :create, request: invalid_attributes, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end
end
