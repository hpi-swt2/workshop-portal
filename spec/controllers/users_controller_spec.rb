require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:user) }

  describe "PUT #update" do

    before :each do
      request.env['HTTP_REFERER'] = root_url
    end

    context "as organizer" do

      before :each do
        sign_in FactoryGirl.create(:user, role: :organizer)
      end

      it "can update the role of a pupil to coach" do
        @test_user = FactoryGirl.create(:user, role: :pupil)
        put :update_role, id: @test_user.id, user: {role: "coach"}
        @test_user.reload
        expect(@test_user.role).to eq("coach")
      end

      it "cannot update the role of an admin" do
        @test_user = FactoryGirl.create(:user, role: :admin)
        put :update_role, id: @test_user.id, user: {role: "coach"}
        @test_user.reload
        expect(@test_user.role).to eq("admin")
      end

      it "cannot update role to admin" do
        @test_user = FactoryGirl.create(:user, role: :coach)
        @test_user.role = "pupil"
        put :update_role, id: @test_user.id, user: {role: "admin"}
        @test_user.reload
        expect(@test_user.role).to eq("coach")
      end
    end

    context "as admin" do

      before :each do
        sign_in FactoryGirl.create(:user, role: :admin)
      end

      it "can update the role of a pupil to coach" do
        @test_user = FactoryGirl.create(:user, role: :pupil)
        put :update_role, id: @test_user.id, user: {role: "coach"}
        @test_user.reload
        expect(@test_user.role).to eq("coach")
      end

      it "can update the role of an admin" do
        @test_user = FactoryGirl.create(:user, role: :admin)
        put :update_role, id: @test_user.id, user: {role: "coach"}
        @test_user.reload
        expect(@test_user.role).to eq("coach")
      end

      it "can update role to admin" do
        @test_user = FactoryGirl.create(:user, role: :coach)
        @test_user.role = "pupil"
        put :update_role, id: @test_user.id, user: {role: "admin"}
        @test_user.reload
        expect(@test_user.role).to eq("admin")
      end
    end
  end
end
