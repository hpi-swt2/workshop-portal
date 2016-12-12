require 'rails_helper'

RSpec.describe AgreementLetter, type: :model do
  before :each do
    @agreement_letter = FactoryGirl.create(:agreement_letter)
    @agreement_letter.set_path
  end

  def mock_writing_to_filesystem
    Dir.mktmpdir do |dir|
      tmp_path = File.join(dir, "tmp.pdf")
      allow_any_instance_of(AgreementLetter).to receive(:path).and_return(tmp_path)
      yield
    end
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

  it "destroys db entry if writing the file fails" do
    mock_writing_to_filesystem do
      allow(File).to receive(:write).and_raise(IOError)
      expect(@agreement_letter.save_file(actual_file)).to be false
      expect(@agreement_letter.persisted?).to be false
    end
  end

  it "destroys db entry if the file is not valid" do
    mock_writing_to_filesystem do
      allow_any_instance_of(AgreementLetter).to receive(:valid_file?).and_return(false)
      expect(@agreement_letter.save_file(actual_file)).to be false
      expect(@agreement_letter.persisted?).to be false
    end
  end

  it "saves a file" do
    mock_writing_to_filesystem do
      expect(@agreement_letter.save_file(actual_file)).to be true
      expect(File.exists?(@agreement_letter.path)).to be true
    end
  end

  it "does not save a file that is too big" do
    mock_writing_to_filesystem do
      stub_const("AgreementLetter::MAX_SIZE", 5)
      expect(@agreement_letter.save_file(actual_file)).to be false
      expect(File.exists?(@agreement_letter.path)).to be false
    end
  end

  it "does not save a file that is not a PDF" do
    mock_writing_to_filesystem do
      expect(@agreement_letter.save_file(fake_file)).to be false
      expect(File.exists?(@agreement_letter.path)).to be false
    end
  end

  it "sets the correct path" do
    @agreement_letter.set_path
    path = Rails.root.join('storage', 'agreement_letters', @agreement_letter.filename).to_s
    expect(@agreement_letter.path).to eq path
  end
end
