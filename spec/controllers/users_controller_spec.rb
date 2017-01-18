require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:user) }

  describe "PUT #update" do

    before :each do
      request.env['HTTP_REFERER'] = root_url

      @user = FactoryGirl.create(:user)
    end

    context "as organizer" do

      before :each do
        request.env['HTTP_REFERER'] = root_url

        login(:organizer)
      end

      it "can update the role of a pupil" do
        @user.role = "pupil"
        put :update_role, id: @user.id, user: {role: "coach"}
        @user.reload
        expect(@user.role).to eq("coach")
      end

      it "cannot update the role of a admin" do
        @user.role = "admin"
        put :update_role, id: @user.id, user: {role: "coach"}
        @user.reload
        expect(@user.role).to_not eq("coach")
      end

      it "cannot update role to admin" do
        @user.role = "pupil"
        put :update_role, id: @user.id, user: {role: "admin"}
        @user.reload
        expect(@user.role).to eq("pupil")
      end
    end
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end
