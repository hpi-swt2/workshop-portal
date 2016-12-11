require 'rails_helper'

RSpec.describe AgreementLetter, type: :model do
  before :each do
    @agreement_letter = FactoryGirl.create(:agreement_letter)
    @agreement_letter.set_path
  end

  let(:actual_file) do
    extend ActionDispatch::TestProcess
    filepath = Rails.root.join('spec/testfiles/actual.pdf')
    fixture_file_upload(filepath, 'application/pdf')
  end

  let(:fake_file) do
    extend ActionDispatch::TestProcess
    filepath = Rails.root.join('spec/testfiles/not_a_pd.f')
    fixture_file_upload(filepath, 'text/x-fortran')
  end

  it "returns the correct filename" do
    user = @agreement_letter.user
    event = @agreement_letter.event
    expect(@agreement_letter.filename).to eq "#{event.id.to_s}_#{user.id.to_s}.pdf"
  end

  it "does not save if the event is unexistent" do
    @agreement_letter.event_id = Event.maximum(:id) + 1
    expect(@agreement_letter.save).to be false
  end

  it "saves a file" do
    Dir.mktmpdir do |dir|
      tmp_path = File.join(dir, "tmp.pdf")
      allow_any_instance_of(AgreementLetter).to receive(:path).and_return(tmp_path)
      expect(@agreement_letter.save_file(actual_file)).to be true
      expect(File.exists?(@agreement_letter.path)).to be true
    end
  end

  it "does not save a file that is too big" do
    Dir.mktmpdir do |dir|
      tmp_path = File.join(dir, "tmp.pdf")
      allow_any_instance_of(AgreementLetter).to receive(:path).and_return(tmp_path)
      stub_const("AgreementLetter::MAX_SIZE", 5)
      expect(@agreement_letter.save_file(actual_file)).to be false
      expect(File.exists?(@agreement_letter.path)).to be false
    end
  end

  it "does not save a file that is not a PDF" do
    Dir.mktmpdir do |dir|
      tmp_path = File.join(dir, "tmp.pdf")
      allow_any_instance_of(AgreementLetter).to receive(:path).and_return(tmp_path)
      expect(@agreement_letter.save_file(fake_file)).to be false
      expect(File.exists?(@agreement_letter.path)).to be false
    end
  end

  it "sets the correct path" do
    pending
  end
end
