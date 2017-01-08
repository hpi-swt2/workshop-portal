require "rails_helper"

describe "Event", type: :feature do
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
end
