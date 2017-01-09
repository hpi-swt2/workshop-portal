require "rails_helper"

describe "Request", type: :feature do
  describe "create page" do

    def fill_in_required_fields
      fill_in "Vorname", :with => "Martina"
      fill_in "Nachname", :with => "Mustermann"
      fill_in "Telefonnummer", :with => "0123456789"
      fill_in "Adresse", :with => "Musterstraße 3"
      fill_in "E-Mail-Adresse", :with => "martina@mustermann.de"
      fill_in "Thema des Workshops", :with => "Musterthema"
    end

    ['Herr', 'Frau', 'Nicht angeben'].each do |form_of_address|
      it "should allow picking #{form_of_address} kind form of address" do
	visit new_request_path
	choose(form_of_address)
	fill_in_required_fields
	click_button I18n.t('.requests.form.create_request')
	expect(page).to have_current_path(request_path(Request.first))
      end
    end
  end

  describe "show page" do
    context "as an organizer" do
      before(:each) do
        profile = FactoryGirl.create(:profile)
        organizer = FactoryGirl.create(:user, role: :organizer, profile: profile)
        login_as(organizer, scope: :user)
      end

      it "should allow me to change the status to :accepted" do
        request = FactoryGirl.create(:request, status: :open)
        visit(request_path(request))
        expect(page).to have_text(request.status)
        click_link I18n.t('requests.form.accept')
        request = Request.find(request.id)
        expect(request.status).to eql(:accepted)
        expect(page).to have_text(I18n.t('requests.notice.was_accepted'))
      end
    end
  end
end
