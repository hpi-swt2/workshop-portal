require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:valid_attributes) { FactoryGirl.attributes_for(:event) }
  let(:file) do
    filepath = Rails.root.join('spec/testfiles/actual.pdf')
    fixture_file_upload(filepath, 'application/pdf')
  end
  let(:dangerous_names) { ["", "../youve_been_hacked.lol"] }

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
        upload_file
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "uploads a file to a material subdirectory" do
      mock_writing_to_filesystem do
        subdir = "subdir"
        mkdir(subdir)
        upload_file(path: subdir)
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "shows error if given path is not a directory" do
      mock_writing_to_filesystem do
        upload_file
        not_a_directory = file.original_filename
        upload_file(path: not_a_directory)
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, not_a_directory, file.original_filename))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "shows error if no file was given" do
      mock_writing_to_filesystem do
        post :upload_material, event_id: @event.to_param
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "shows error if file saving was not successfull" do
      mock_writing_to_filesystem do
        allow(File).to receive(:write).and_raise(IOError)
        upload_file
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:saving_fails, scope: 'events.material_area'))
      end
    end

    it "sanitizes filenames" do
      pending "TODO: Sanitizing"
      mock_writing_to_filesystem do
        dangerous_name = "../hacked_you.lol"
        allow_any_instance_of(Rack::Test::UploadedFile).to receive(:original_filename).and_return(dangerous_name)
        upload_file
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
        mkdir(dirname)
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(Dir.exists?(File.join(@event.material_path, dirname)))
        expect(flash[:notice]).to match(I18n.t(:dir_created, scope: 'events.material_area'))
      end
    end

    it "sanitizes directory names" do
      pending "TODO: Sanitizing"
      mock_writing_to_filesystem do
        dangerous_name = "../hacked_you.lol"
        mkdir(dangerous_name)
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, dangerous_name))).to be false
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "sanitizes path names" do
      pending "TODO: Sanitizing"
      mock_writing_to_filesystem do
        name = "subdir"
        dangerous_path = "../hacked_you.lol"
        mkdir(name, dangerous_path)
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, dangerous_path, name))).to be false
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "does not overwrite existing directories" do
      pending "TODO: Warning message when overwriting was avoided"
      mock_writing_to_filesystem do
        name = "subdir"
        filename = "gentoo.txt"
        mkdir(name)
        upload_file(name: filename, dir: name) # empty file to test if first dir was deleted
        mkdir(name)
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, name, "gentoo.txt")))
        expect(flash[:alert]).to match(I18n.t(:already_exists, scope: 'events.material_area'))
      end
    end

    it "does not overwrite existing files" do
      pending "TODO: Warning message when overwriting was avoided"
      mock_writing_to_filesystem do
        name = "gentoo.txt"
        upload_file(name: name)
        mkdir(name)
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.directory?(File.join(@event.material_path, name))).to be false
        expect(flash[:alert]).to match(I18n.t(:already_exists, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #remove_material" do
    it "removes a file" do
      mock_writing_to_filesystem do
        path = "gentoo.txt"
        upload_file(name: path)
        post :remove_material, event_id: @event.to_param, path: path
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, path))).to be false
        expect(flash[:notice]).to match(I18n.t(:file_removed, scope: 'events.material_area'))
      end
    end

    it "removes a directory" do
      mock_writing_to_filesystem do
        path = "darjeeling"
        mkdir(path)
        post :remove_material, event_id: @event.to_param, path: path
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, path))).to be false
        expect(flash[:notice]).to match(I18n.t(:file_removed, scope: 'events.material_area'))
      end
    end

    it "sanitizes path names" do
      pending "TODO: Write decent test"
      mock_writing_to_filesystem do
        dangerous_path = "../your_root_directory"
        post :remove_material, event_id: @event.to_param, path: dangerous_path
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "shows an error when given a non-existent file" do
      pending "TODO: show alert"
      mock_writing_to_filesystem do
        path = "photo_of_my_girlfriend.jpg"
        post :remove_material, event_id: @event.to_param, path: path
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #move_material" do
    it "moves a file to another directory" do
      mock_writing_to_filesystem do
        subdir = "subdir"
        mkdir(subdir)
        upload_file
        post :move_material, event_id: @event.to_param, from: file.original_filename, to: subdir
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:file_moved, scope: 'events.material_area'))
      end
    end

    it "moves a directory to another directory" do
      mock_writing_to_filesystem do
        name = "testdir"
        subdir = "subdir"
        mkdir(subdir)
        mkdir(name)
        post :move_material, event_id: @event.to_param, from: name, to: subdir
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(Dir.exists?(File.join(@event.material_path, subdir, name)))
        expect(flash[:notice]).to match(I18n.t(:file_moved, scope: 'events.material_area'))
      end
    end

    it "sanitizes from-path names" do
    end

    it "sanitizes to-path names" do
    end

    it "shows an error instead of overwriting a file" do
      pending "TODO: do not overwrite file"
      mock_writing_to_filesystem do
        subdir = "rickenbacker"
        text = "Ramona Flowers"
        upload_file
        mkdir(subdir)
        upload_file(name: file.original_filename, dir: subdir, content: text)
        post :move_material, event_id: @event.to_param, from: file.original_filename, to: subdir
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename)))
        expect(File.read(File.join(@event.material_path, subdir, file.original_filename))).to eq text
        expect(flash[:alert]).to match(I18n.t(:already_exists, scope: 'events.material_area'))
      end
    end

    it "shows an error when given a non-existent from-path" do
      pending "TODO: show error"
      mock_writing_to_filesystem do
        subdir = "subdir"
        mkdir(subdir)
        post :move_material, event_id: @event.to_param, from: file.original_filename, to: subdir
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "shows an error when given a non-existent to-path" do
      pending "TODO: show error"
      mock_writing_to_filesystem do
        subdir = "subdir"
        upload_file
        post :move_material, event_id: @event.to_param, from: file.original_filename, to: subdir
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "shows an error when moving a directory into itself" do
      mock_writing_to_filesystem do
        dir = "dir"
        mkdir(dir)
        post :move_material, event_id: @event.to_param, from: dir, to: dir
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, dir)))
        expect(flash[:alert]).to match(I18n.t(:cant_move_in_child, scope: 'events.material_area'))
      end
    end

    it "shows an error when moving a directory into its own subdirectory" do
      mock_writing_to_filesystem do
        dir = "dir"
        subdir = "subdir"
        mkdir(dir)
        mkdir(subdir, path: dir)
        post :move_material, event_id: @event.to_param, from: dir, to: File.join(dir, subdir)
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, dir)))
        expect(File.exists?(File.join(@event.material_path, dir, subdir)))
        expect(flash[:alert]).to match(I18n.t(:cant_move_in_child, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #rename_material" do
    it "renames a file" do
      mock_writing_to_filesystem do
        new_name = "otter_in_my_water"
        upload_file
        post :rename_material, event_id: @event.to_param, from: file.original_filename, to: new_name
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename))).to be false
        expect(File.exists?(File.join(@event.material_path, new_name)))
        expect(flash[:notice]).to match(I18n.t(:file_renamed, scope: 'events.material_area'))
      end
    end

    it "renames a directory" do
      mock_writing_to_filesystem do
        name = "meduka"
        new_name = "meguca"
        mkdir(name)
        post :rename_material, event_id: @event.to_param, from: name, to: new_name
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(Dir.exists?(File.join(@event.material_path, new_name)))
        expect(Dir.exists?(File.join(@event.material_path, name))).to be false
        expect(flash[:notice]).to match(I18n.t(:file_renamed, scope: 'events.material_area'))
      end
    end

    it "sanitizes from-path names" do
      pending "TODO: Sanitizing"
      fail
    end

    it "sanitizes to-path names" do
      pending "TODO: Sanitizing"
      fail
    end

    it "does not move files to a different directory" do
      pending "TODO: Sanitizing"
      fail
    end

    it "shows an error instead of overwriting a file" do
      pending "TODO: Warning message when overwriting was avoided"
      mock_writing_to_filesystem do
        first_file = "purity"
        text = "fresh_blood"
        upload_file
        upload_file(name: first_file, content: text)
        post :rename_material, event_id: @event.to_param, from: file.original_filename, to: first_file
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename)))
        expect(File.exists?(File.join(@event.material_path, first_file)))
        expect(File.read(File.join(@event.material_path, first_file))).to eq text
        expect(flash[:alert]).to match(I18n.t(:already_exists, scope: 'events.material_area'))
      end
    end

    it "shows an error when given a non-existent from-path" do
      pending "TODO: Error message when renaming non-existent file"
      mock_writing_to_filesystem do
        new_name = "serenity"
        post :rename_material, event_id: @event.to_param, from: file.original_filename, to: new_name
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, new_name))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #download_material" do
    it "downloads a file from the event's root material directory" do
      mock_writing_to_filesystem do
        upload_file
        post :download_material, event_id: @event.to_param, file: file.original_filename
        expect(response.header['Content-Type']).to match('application/pdf')
      end
    end

    it "downloads a file from a subdirectory" do
      mock_writing_to_filesystem do
        subdir = "bebop"
        mkdir(subdir)
        upload_file(path: subdir)
        post :download_material, event_id: @event.to_param, file: File.join(subdir, file.original_filename)
        expect(response.header['Content-Type']).to match('application/pdf')
      end
    end

    it "downloads a directory as a zip" do
      mock_writing_to_filesystem do
        subdir = "normandy"
        mkdir(subdir)
        post :download_material, event_id: @event.to_param, file: subdir
        expect(response.header['Content-Type']).to match('application/zip')
      end
    end

    it "shows error if no file was given" do
      mock_writing_to_filesystem do
        upload_file
        post :download_material, event_id: @event.to_param
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "shows error if file was not found" do
      mock_writing_to_filesystem do
        filename = "non-existing/file.pdf"
        upload_file
        post :download_material, event_id: @event.to_param, file: filename
        expect(response).to redirect_to :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end
  end

  def upload_file(options = {})
    if options[:name].to_s == ""
      post :upload_material, event_id: @event.to_param, path: options[:path], file_upload: file
    else
      File.write(File.join(@event.material_path, options[:dir].to_s, options[:name]), options[:content].to_s)
    end
  end

  def mkdir(name, options = {})
    path = options[:path] ? File.join(@event.material_path, options[:path]) : ""
    post :make_material_folder, event_id: @event.to_param, path: path, name: name
  end
end
