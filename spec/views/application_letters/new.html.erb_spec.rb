require 'rails_helper'

RSpec.describe "application_letters/new", type: :view do
  before(:each) do
    assign(:application_letter, FactoryGirl.build(:application_letter))
  end

  it "renders new application form" do
    render

    assert_select "form[action=?][method=?]", application_letters_path, "post" do
      assert_select "textarea#application_letter_motivation[name=?]", "application_letter[motivation]"
      assert_select "input#application_letter_user_id[name=?]", "application_letter[user_id]"
      assert_select "textarea#application_letter_experience[name=?]", "application_letter[experience]"
      assert_select "textarea#application_letter_coding_skills[name=?]", "application_letter[coding_skills]"
      assert_select "input#application_letter_emergency_number[name=?]", "application_letter[emergency_number]"
      assert_select "input#application_letter_vegeterian[name=?]", "application_letter[vegeterian]"
      assert_select "input#application_letter_vegan[name=?]", "application_letter[vegan]"
      assert_select "input#application_letter_allergic[name=?]", "application_letter[allergic]"
      assert_select "input#application_letter_allergies[name=?]", "application_letter[allergies]"
      assert_select "input#application_letter_grade[name=?]", "application_letter[grade]"

    end
  end

  it "renders large enough textareas" do
    render :template => "application_letters/_form.html.erb"

    expect(rendered).to have_selector("textarea[rows='10'][name='application_letter\[motivation\]']")
    expect(rendered).to have_selector("textarea[rows='5'][name='application_letter\[coding_skills\]']")
  end

  it "displays help text for motivation textarea" do
    render :template => "application_letters/_form.html.erb"

    expect(rendered).to have_text("Wie gut beherrscht du sie deiner Meinung nach (Anfänger, Fortgeschrittener, Experte)? Was kannst du in den Programmiersprachen realisieren/hast du realisiert? Je ausführlicher du diese Beschreibst, desto besser können wir schon in der Vorbereitung der Veranstaltung darauf eingehen. Programmierkenntnisse sind keine  Voraussetzung zur Teilnahme. Diese Information wird zur Gruppeneinteilung benötigt.")
  end
end
