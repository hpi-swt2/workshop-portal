# require 'spec_helper'

# describe ApplicationController do

#   describe "test #add_missing_permission_flashes" do
#     it "sets the warning flash to contains messages" do
#     	user = FactoryGirl.create(:user)
#     	event = FactoryGirl.create(:event)
#     	FactoryGirl.create(:application_letter_accepted, user: user, event: event)
#     	get :index
#     	subject.add_missing_permission_flashes
#       expect(flash.now["warning"]).to_not exist
#     end
#   end

# end