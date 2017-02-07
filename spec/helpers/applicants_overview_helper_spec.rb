require "rails_helper"
require "spec_helper"

describe ApplicantsOverviewHelper do
  describe "#sort_application_letters" do
    it "should not be exploitable to execute arbitrary methods" do

    	dangerous_methods = ["destroy", "destroy_all", "create!", "delete_all"]

    	dangerous_methods.each do |method|
    		controller.params[:sort] = method
      	expect{helper.sort_application_letters}.to raise_error(CanCan::AccessDenied)
    	end
    end
  end
end