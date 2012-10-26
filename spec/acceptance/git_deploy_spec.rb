describe 'Deployment using git' do
  let(:test_repo_path)     { "#{Dir.pwd}/.tmp/test-repo" }
  let(:fixture_path)       { "#{Dir.pwd}/spec/fixtures/project" }

  before :all do
    recreate_vm!
    setup_vm!

    `cp scripts/apply-manifests #{fixture_path}/scripts/apply-manifests`
  end

  context 'working folder' do
    before :all do
      cleanup!
      init_and_push_repo({'test-file' => 'Contents...'}, test_repo_path)
    end

    it 'gets created after initial push' do
      run("sudo ls -a #{remote_working_dir}").should include('.git')
    end

    it 'is updated on subsequent pushes' do
      Dir.chdir test_repo_path do
        `git mv test-file renamed`
        commit_and_push_repo
      end

      run("sudo ls #{remote_working_dir}").should_not include('test-file')
      run("sudo ls #{remote_working_dir}").should include('renamed')
    end
  end

  context 'puppet apply' do
    before :all do
      cleanup!
      `cp -r #{fixture_path}/* #{test_repo_path}`
      init_and_push_repo({}, test_repo_path)
    end

    it 'supports puppet forge modules' do
      run('sudo ls /tmp').should include('stdlib-test')
    end

    it 'supports git modules' do
      run('sudo ls -a /home/vagrant').should include('.rbenv')
    end

    it 'loads hiera configs' do
      run('cat /tmp/hiera').should == 'value from hiera'
    end

    it 'supports "global" templates' do
      run('cat /tmp/template').should == 'Template working!'
    end
  end

  def cleanup!
    run("sudo rm -rf #{remote_working_dir}", :error_check => true)
    `rm -rf #{test_repo_path}` if Dir.exist? test_repo_path
    `mkdir -p #{test_repo_path}`
  end
end
