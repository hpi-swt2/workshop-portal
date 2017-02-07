require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:valid_attributes) { FactoryGirl.attributes_for(:event) }
  let(:valid_session) { {} }
  let(:file) do
    filepath = Rails.root.join('spec/testfiles/actual.pdf')
    fixture_file_upload(filepath, 'application/pdf')
  end

  def mock_writing_to_filesystem
    Dir.mktmpdir do |dir|
      allow_any_instance_of(Event).to receive(:material_path).and_return(dir)
      yield
    end
  end

  before :each do
    @event = Event.create! valid_attributes
    @user = FactoryGirl.create(:user_with_profile, role: :coach)
    sign_in @user
  end

  describe "POST #upload_material" do
    it "uploads a file to the event's root material directory" do
      mock_writing_to_filesystem do
        post :upload_material, event_id: @event.to_param, session: valid_session, path: '', file_upload: file
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "uploads a file to a material subdirectory" do
      mock_writing_to_filesystem do
        subdir = "subdir"
        Dir.mkdir(File.join(@event.material_path, subdir))
        post :upload_material, event_id: @event.to_param, session: valid_session, path: subdir, file_upload: file
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "shows error if given path is not a directory" do
      mock_writing_to_filesystem do
        post :upload_material, event_id: @event.to_param, session: valid_session, path: '', file_upload: file
        not_a_directory = file.original_filename
        post :upload_material, event_id: @event.to_param, session: valid_session, path: not_a_directory, file_upload: file
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, not_a_directory, file.original_filename))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "shows error if no file was given" do
      mock_writing_to_filesystem do
        post :upload_material, event_id: @event.to_param, session: valid_session
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "shows error if file saving was not successfull" do
      mock_writing_to_filesystem do
        allow(File).to receive(:write).and_raise(IOError)
        post :upload_material, event_id: @event.to_param, session: valid_session, file_upload: file
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:saving_fails, scope: 'events.material_area'))
      end
    end

    it "sanitizes filenames" do
      pending "TODO: Sanitizing"
      mock_writing_to_filesystem do
        dangerous_name = "../hacked_you.lol"
        allow_any_instance_of(Rack::Test::UploadedFile).to receive(:original_filename).and_return(dangerous_name)
        post :upload_material, event_id: @event.to_param, session: valid_session, path: '', file_upload: file
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename))).to be false
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #make_material_folder" do
    it "creates a directory" do
      mock_writing_to_filesystem do
        dirname = "testdir"
        path = ''
        post :make_material_folder, event_id: @event.to_param, session: valid_session, path: path, name: dirname
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(Dir.exists?(File.join(@event.material_path, path, dirname)))
        expect(flash[:notice]).to match(I18n.t(:dir_created, scope: 'events.material_area'))
      end
    end

    it "sanitizes directory names" do
    end

    it "does not overwrite existing directories" do
    end

    it "does not overwrite existing files" do
    end
  end

  describe "POST #remove_material" do
    it "removes a file" do
    end

    it "does not remove a directory" do
    end

    it "shows an error when given a non-existent file" do
    end
  end

  describe "POST #move_material" do
    it "moves a file" do
    end

    it "moves a directory" do
    end

    it "shows an error instead of overwriting a file" do
    end

    it "shows an error when given a non-existent from-path" do
    end

    it "shows an error when given a non-existent to-path" do
    end
  end

  describe "POST #remove_material_folder" do
    it "removes a directory" do
    end

    it "does not remove a file" do
    end

    it "shows an error when given a non-existent directory" do
    end
  end

  describe "POST #download_material" do
    it "downloads a file from the event's root material directory" do
      mock_writing_to_filesystem do
        post :upload_material, event_id: @event.to_param, session: valid_session, file_upload: file
        post :download_material, event_id: @event.to_param, session: valid_session, file: file.original_filename
        expect(response.header['Content-Type']).to match('application/pdf')
      end
    end

    it "downloads a file from a subdirectory" do
    end

    it "downloads a directory as a zip" do
    end

    it "shows error if no file was given" do
      mock_writing_to_filesystem do
        post :upload_material, event_id: @event.to_param, session: valid_session, file_upload: file
        post :download_material, event_id: @event.to_param, session: valid_session
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "shows error if file was not found" do
      mock_writing_to_filesystem do
        filename = "non-existing/file.pdf"
        post :upload_material, event_id: @event.to_param, session: valid_session, file_upload: file
        post :download_material, event_id: @event.to_param, session: valid_session, file: filename
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end
  end
end
