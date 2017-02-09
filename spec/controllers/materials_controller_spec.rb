require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  let(:valid_attributes) { FactoryGirl.attributes_for(:event) }
  let(:file) do
    filepath = Rails.root.join('spec/testfiles/actual.pdf')
    fixture_file_upload(filepath, 'application/pdf')
  end
  let(:dangerous_names) { ["", "../youve_been_hacked.lol"] }

  def mock_writing_to_filesystem
    Dir.mktmpdir do |dir|
      # add extra level to clean up after simulated directory traversal attack
      subdir = File.join(dir, "testdir") 
      Dir.mkdir(subdir)
      allow_any_instance_of(Event).to receive(:material_path).and_return(subdir)
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
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "uploads a file to a material subdirectory" do
      mock_writing_to_filesystem do
        subdir = "subdir"
        mkdir(subdir)
        upload_file(path: subdir)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "shows error if given path is not a directory" do
      mock_writing_to_filesystem do
        upload_file
        not_a_directory = file.original_filename
        upload_file(path: not_a_directory)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, not_a_directory, file.original_filename))).to be false
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end

    it "creates the material_directory if not already present" do
      mock_writing_to_filesystem do
        FileUtils.rm_rf(@event.material_path) if File.exists?(@event.material_path)
        upload_file
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(Dir.exists?(@event.material_path))
        expect(File.exists?(File.join(@event.material_path, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:success_message, scope: 'events.material_area'))
      end
    end

    it "shows error if no file was given" do
      mock_writing_to_filesystem do
        post :upload_material, event_id: @event.to_param
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "shows error if file saving was not successfull" do
      mock_writing_to_filesystem do
        allow(File).to receive(:write).and_raise(IOError)
        upload_file
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:saving_fails, scope: 'events.material_area'))
      end
    end

    it "sanitizes filenames" do
      mock_writing_to_filesystem do
        dangerous_name = "../hacked_you.lol"
        allow_any_instance_of(Rack::Test::UploadedFile).to receive(:original_filename).and_return(dangerous_name)
        upload_file
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #make_material_folder" do
    it "creates a directory" do
      mock_writing_to_filesystem do
        dirname = "testdir"
        mkdir(dirname)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(Dir.exists?(File.join(@event.material_path, dirname)))
        expect(flash[:notice]).to match(I18n.t(:dir_created, scope: 'events.material_area'))
      end
    end

    it "creates the material_directory if not already present" do
      mock_writing_to_filesystem do
        FileUtils.rm_rf(@event.material_path) if File.exists?(@event.material_path)
        subdir = "subdir"
        mkdir(subdir)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(Dir.exists?(@event.material_path))
        expect(Dir.exists?(File.join(@event.material_path, subdir)))
        expect(flash[:notice]).to match(I18n.t(:dir_created, scope: 'events.material_area'))
      end
    end

    it "sanitizes directory names" do
      mock_writing_to_filesystem do
        dangerous_name = "../hacked_you.lol"
        mkdir(dangerous_name)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, dangerous_name))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "does not accept unset parameters" do
      mock_writing_to_filesystem do
        post :make_material_folder, event_id: @event.to_param, path: ''
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "sanitizes path names" do
      mock_writing_to_filesystem do
        name = "subdir"
        dangerous_path = "../hacked_you.lol"
        mkdir(name, path: dangerous_path)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "does not overwrite existing directories" do
      mock_writing_to_filesystem do
        name = "subdir"
        filename = "gentoo.txt"
        mkdir(name)
        upload_file(name: filename, path: name) # empty file to test if first dir was deleted
        mkdir(name)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, name, "gentoo.txt")))
        expect(flash[:alert]).to match(I18n.t(:already_exists, scope: 'events.material_area'))
      end
    end

    it "does not overwrite existing files" do
      mock_writing_to_filesystem do
        name = "gentoo.txt"
        upload_file(name: name)
        mkdir(name)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.directory?(File.join(@event.material_path, name))).to be false
        expect(flash[:alert]).to match(I18n.t(:already_exists, scope: 'events.material_area'))
      end
    end

    it "does not create an directory in an unexisting directory" do
      mock_writing_to_filesystem do
        name = "mydir"
        path = "myunexistingdir"
        mkdir(name, path: path)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.directory?(File.join(@event.material_path, path, name))).to be false
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #remove_material" do
    it "removes a file" do
      mock_writing_to_filesystem do
        path = "gentoo.txt"
        upload_file(name: path)
        remove_file(path)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, path))).to be false
        expect(flash[:notice]).to match(I18n.t(:file_removed, scope: 'events.material_area'))
      end
    end

    it "does not accept unset parameters" do
      mock_writing_to_filesystem do
        post :remove_material, event_id: @event.to_param
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "removes a directory" do
      mock_writing_to_filesystem do
        path = "darjeeling"
        mkdir(path)
        remove_file(path)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, path))).to be false
        expect(flash[:notice]).to match(I18n.t(:file_removed, scope: 'events.material_area'))
      end
    end

    it "sanitizes path names" do
      mock_writing_to_filesystem do
        dangerous_path = "../your_root_directory"
        remove_file(dangerous_path)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "shows an error when given a non-existent file" do
      mock_writing_to_filesystem do
        path = "photo_of_my_girlfriend.jpg"
        remove_file(path)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #move_material" do
    it "moves a file to another directory" do
      mock_writing_to_filesystem do
        subdir = "subdir"
        mkdir(subdir)
        upload_file
        move_file(file.original_filename, subdir)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename)))
        expect(flash[:notice]).to match(I18n.t(:file_moved, scope: 'events.material_area'))
      end
    end


    it "sanitizes path names" do
      mock_writing_to_filesystem do
        dangerous_path = "../your_root_directory"
        path = "myfile.txt"
        move_file(dangerous_path, path)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "moves a directory to another directory" do
      mock_writing_to_filesystem do
        name = "testdir"
        subdir = "subdir"
        mkdir(subdir)
        mkdir(name)
        move_file(name, subdir)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(Dir.exists?(File.join(@event.material_path, subdir, name)))
        expect(flash[:notice]).to match(I18n.t(:file_moved, scope: 'events.material_area'))
      end
    end

    it "does not accept unset parameters" do
      mock_writing_to_filesystem do
        post :move_material, event_id: @event.to_param
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "sanitizes from-path names" do
    end

    it "sanitizes to-path names" do
    end

    it "shows an error instead of overwriting a file" do
      mock_writing_to_filesystem do
        subdir = "rickenbacker"
        text = "Ramona Flowers"
        upload_file
        mkdir(subdir)
        upload_file(name: file.original_filename, path: subdir, content: text)
        move_file(file.original_filename, subdir)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename)))
        expect(File.read(File.join(@event.material_path, subdir, file.original_filename))).to eq text
        expect(flash[:alert]).to match(I18n.t(:already_exists, scope: 'events.material_area'))
      end
    end

    it "shows an error when given a non-existent from-path" do
      mock_writing_to_filesystem do
        subdir = "subdir"
        mkdir(subdir)
        move_file(file.original_filename, subdir)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename))).to be false
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end

    it "shows an error when given a non-existent to-path" do

      mock_writing_to_filesystem do
        subdir = "subdir"
        upload_file
        move_file(file.original_filename, subdir)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, subdir, file.original_filename))).to be false
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end

    it "shows an error when moving a directory into itself" do
      mock_writing_to_filesystem do
        dir = "dir"
        mkdir(dir)
        move_file(dir, dir)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
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
        move_file(dir, [dir, subdir])
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
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
        rename(file.original_filename, new_name)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
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
        rename(name, new_name)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(Dir.exists?(File.join(@event.material_path, new_name)))
        expect(Dir.exists?(File.join(@event.material_path, name))).to be false
        expect(flash[:notice]).to match(I18n.t(:file_renamed, scope: 'events.material_area'))
      end
    end

    it "does not accept unset parameters" do
      mock_writing_to_filesystem do
        post :rename_material, event_id: @event.to_param
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "sanitizes from-path names" do
      mock_writing_to_filesystem do
        invalid_from = "...../..."
        to = 'dir/test'
        mkdir('dir')
        rename(invalid_from, to)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, to))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "sanitizes to-path names" do
      mock_writing_to_filesystem do
        from = 'file'
        invalid_to = '../../../test/invalid'
        mkdir('dir')
        rename(from, invalid_to)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, invalid_to))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "does not move files to a different directory" do
      mock_writing_to_filesystem do
        from = 'file'
        invalid_to = 'test/invalid'
        mkdir('dir')
        rename(from, invalid_to)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, invalid_to))).to be false
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "does nothing when renaming to the same name" do
      mock_writing_to_filesystem do
        upload_file
        rename(file.original_filename, file.original_filename)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename)))
      end
    end

    it "shows an error instead of overwriting a file" do
      mock_writing_to_filesystem do
        first_file = "purity"
        text = "fresh_blood"
        upload_file
        upload_file(name: first_file, content: text)
        rename(file.original_filename, first_file)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, file.original_filename)))
        expect(File.exists?(File.join(@event.material_path, first_file)))
        expect(File.read(File.join(@event.material_path, first_file))).to eq text
        expect(flash[:alert]).to match(I18n.t(:already_exists, scope: 'events.material_area'))
      end
    end

    it "shows an error when given a non-existent from-path" do
      mock_writing_to_filesystem do
        new_name = "serenity"
        rename(file.original_filename, new_name)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(File.exists?(File.join(@event.material_path, new_name))).to be false
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end
  end

  describe "POST #download_material" do
    it "downloads a file from the event's root material directory" do
      mock_writing_to_filesystem do
        upload_file
        download_file(file.original_filename)
        expect(response.header['Content-Type']).to match('application/pdf')
      end
    end

    it "downloads a file from a subdirectory" do
      mock_writing_to_filesystem do
        subdir = "bebop"
        mkdir(subdir)
        upload_file(path: subdir)
        download_file(subdir, file.original_filename)
        expect(response.header['Content-Type']).to match('application/pdf')
      end
    end

    it "does not accept an hackish pathname" do
      mock_writing_to_filesystem do
        subdir = "/mypath/../"
        download_file(subdir, '')
        expect(flash[:alert]).to match(I18n.t(:invalid_path_given, scope: 'events.material_area'))
      end
    end

    it "downloads a directory as a zip" do
      mock_writing_to_filesystem do
        subdir = "normandy"
        mkdir(subdir)
        download_file(subdir)
        expect(response.header['Content-Type']).to match('application/zip')
      end
    end

    it "shows error if no file was given" do
      mock_writing_to_filesystem do
        upload_file
        post :download_material, event_id: @event.to_param
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:no_file_given, scope: 'events.material_area'))
      end
    end

    it "shows error if file was not found" do
      mock_writing_to_filesystem do
        filename = "non-existing/file.pdf"
        upload_file
        download_file(filename)
        expect(response).to redirect_to :controller => :events, :action => :show, :id => @event.id
        expect(flash[:alert]).to match(I18n.t(:download_file_not_found, scope: 'events.material_area'))
      end
    end
  end

  describe "MaterialController private methods" do
    # /
    #   dir1/
    #     subdir/
    #     subdir2/
    #       subsubdir/
    #         file3
    #     subdir3/
    #       file1
    #       file2
    #     file
    #   dir2/
    #     subdir/
    #       subsubdir/
    #   dir3/
    #   file1
    #   file2
    #   file3
    before :each do
      @event.material_path
      mkdir("dir1")
        mkdir("subdir", path: "dir1")
        mkdir("subdir2", path: "dir1")
          mkdir("subsubdir", path: ["dir1", "subdir2"])
            upload_file(name: "file3", path: ["dir1", "subdir2", "subsubdir"])
        mkdir("subdir3", path: "dir1")
          upload_file(name: "file1", path: ["dir1", "subdir3"])
          upload_file(name: "file2", path: ["dir1", "subdir3"])
        upload_file(name: "file", path: "dir1")
      mkdir("dir2")
        mkdir("subdir", path: "dir2")
          mkdir("subsubdir", path: ["dir2", "subdir"])
      mkdir("dir3")
      upload_file(name: "file1")
      upload_file(name: "file2")
      upload_file(name: "file3")
    end

    it "returns a complete list of the material filesystem" do
      namelist = lambda { |list| list.map { |hash| hash[:name] } }

      root_list = EventsController.new.send(:get_material_files, @event.material_path)
      expected_root_namelist = ["dir1", "dir2", "dir3", "file1", "file2", "file3"]
      expect(namelist.call(root_list)).to eq expected_root_namelist

        dir1_list = root_list[0][:content]
        expected_dir1_namelist = ["subdir", "subdir2", "subdir3", "file"]
        expect(namelist.call(dir1_list)).to eq expected_dir1_namelist

          dir1_subdir_list = dir1_list[0][:content]
          expect(dir1_subdir_list).to be_empty

          dir1_subdir2_list = dir1_list[1][:content]
          expected_dir1_subdir2_namelist = ["subsubdir"]
          expect(namelist.call(dir1_subdir2_list)).to eq expected_dir1_subdir2_namelist

            dir1_subdir2_subsubdir_list = dir1_subdir2_list[0][:content]
            expected_dir1_subdir2_subsubdir_namelist = ["file3"]
            expect(namelist.call(dir1_subdir2_subsubdir_list)).to eq expected_dir1_subdir2_subsubdir_namelist

          dir1_subdir3_list = dir1_list[2][:content]
          expected_dir1_subdir3_namelist = ["file1", "file2"]
          expect(namelist.call(dir1_subdir3_list)).to eq expected_dir1_subdir3_namelist

        dir2_list = root_list[1][:content]
        expected_dir2_namelist = ["subdir"]
        expect(namelist.call(dir2_list)).to eq expected_dir2_namelist

          dir2_subdir_list = dir2_list[0][:content]
          expected_dir2_subdir_namelist = ["subsubdir"]
          expect(namelist.call(dir2_subdir_list)).to eq expected_dir2_subdir_namelist

            dir2_subdir_subsubdir_list = dir2_subdir_list[0][:content]
            expect(dir2_subdir_subsubdir_list).to be_empty
    end

    it "returns a zipped version of the material filesystem" do
      download_file
      zip = response.body
      Dir.mktmpdir do |dir|
        Zip::InputStream.open(StringIO.new(zip)) do |zip_file|
          zip_file.each do |f|
            fpath = File.join(dir, f.name)
            zip_file.extract(f, fpath)
          end
        end
        Dir[File.join(@event.material_path, '**', '*')].each do |filename|
          expect(File.exists?(File.join(dir, filename)))
        end
      end
    end
  end

  def upload_file(options = {})
    path = options[:path] ? File.join(options[:path]) : ""
    if options[:name].to_s == ""
      post :upload_material, event_id: @event.to_param, path: path, file_upload: file
    else
      File.write(File.join(@event.material_path, path, options[:name]), options[:content].to_s)
    end
  end

  def mkdir(name, options = {})
    path = options[:path] ? File.join(options[:path]) : ""
    post :make_material_folder, event_id: @event.to_param, path: path, name: name
  end

  def rename(from, to)
    post :rename_material, event_id: @event.to_param, from: from, to: to
  end

  def move_file(from, to)
    to_path = File.join(to)
    post :move_material, event_id: @event.to_param, from: from, to: to_path
  end

  def download_file(*path_components)
    path = File.join(path_components)
    post :download_material, event_id: @event.to_param, file: path
  end

  def remove_file(path)
    post :remove_material, event_id: @event.to_param, path: path
  end
end
