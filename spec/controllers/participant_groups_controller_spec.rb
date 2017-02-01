require 'rails_helper'

RSpec.describe ParticipantGroupsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.build(:participant_group).attributes }
  let(:invalid_attributes) { FactoryGirl.build(:participant_group, event: nil).attributes }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ApplicationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:each) do
    request.env['HTTP_REFERER'] = events_path
  end

  context "with an existing participant_group" do
    before :each do
      @participant_group = ParticipantGroup.create! valid_attributes
    end

    describe "PUT #update" do
      before :each do
        sign_in FactoryGirl.create(:user, role: :admin)
      end

      context "with valid params" do
        let(:new_group) { {group: 9} }

        it "assigns the requested participant group as @participant_group" do
          put :update, id: @participant_group.to_param, participant_group: new_group, session: valid_session
          expect(assigns(:participant_group)).to eq(@participant_group)
        end

        it "updates the group" do
          put :update, id: @participant_group.to_param, participant_group: new_group, session: valid_session
          @participant_group.reload
          expect(@participant_group.group).to eq(new_group[:group])
        end

        it "redirects back" do
          put :update, id: @participant_group.to_param, participant_group: new_group, session: valid_session
          expect(response).to redirect_to(request.env['HTTP_REFERER'])
        end

        it "redirects to root when HTTP_REFERER invalid" do
          request.env['HTTP_REFERER'] = nil
          put :update, id: @participant_group.to_param, participant_group: new_group, session: valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      context "with invalid params" do
        let(:invalid_group) { {group: nil} }
        it "assigns the requested participant group as @participant_group" do
          put :update, id: @participant_group.to_param, participant_group: invalid_group, session: valid_session
          expect(assigns(:participant_group)).to eq(@participant_group)
        end

        it "does not update the group" do
          put :update, id: @participant_group.to_param, participant_group: invalid_group, session: valid_session
          expect(@participant_group.group).to_not eq(invalid_group[:group])
        end
      end
    end
  end

end
