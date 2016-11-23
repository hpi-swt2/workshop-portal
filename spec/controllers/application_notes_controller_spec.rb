require 'rails_helper'

RSpec.describe ApplicationNotesController, type: :controller do
  let(:application_letter) { FactoryGirl.create(:application_letter) }
  let(:valid_attributes) { FactoryGirl.build(:application_note, application_letter: application_letter).attributes }
  let(:invalid_attributes) { ApplicationNote.new(note: "", application_letter: application_letter).attributes }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ApplicationNotesController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  describe "POST #create" do
    context "with valid params" do
      it "creates a new ApplicationNote" do
        expect {
          post :create, application_letter_id: application_letter.id, application_note: valid_attributes, session: valid_session
        }.to change(ApplicationNote, :count).by(1)
      end

      it "assigns a newly created application note as @application_note" do
        post :create, application_letter_id: application_letter.id, application_note: valid_attributes, session: valid_session
        expect(assigns(:application_note)).to be_a(ApplicationNote)
        expect(assigns(:application_note)).to be_persisted
      end

      it "redirects to the corresponding application" do
        post :create, application_letter_id: application_letter.id, application_note: valid_attributes, session: valid_session
        expect(response).to redirect_to(assigns(:application_note).application_letter)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved application note as @application_note" do
        post :create, application_letter_id: application_letter.id, application_note: invalid_attributes, session: valid_session
        expect(assigns(:application_note)).to be_a_new(ApplicationNote)
      end

      it "renders application_letters/show to show errors" do
        post :create, application_letter_id: application_letter.id, application_note: invalid_attributes, session: valid_session
        expect(response).to render_template("application_letters/show")
      end
    end
  end
end
