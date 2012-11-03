require 'fileutils'

describe 'Initial setup script' do
  before :all do
    recreate_vm!
    setup_vm!
  end

  it 'installs rubygems system package' do
    run("dpkg -l rubygems | grep -q -E 'ii\s+rubygems'", :error_check => true)
  end

  it 'installs puppet 3.0 as a gem' do
    run('puppet --version').should =~ /^3\.0/
    # It would be available from /usr/bin/puppet if was installed as a package
    run('which puppet').should == '/usr/local/bin/puppet'
  end

  it 'installs librarian-puppet gem' do
    run('which librarian-puppet').should == '/usr/local/bin/librarian-puppet'
    run('librarian-puppet version').should =~ /v0\.9\.\d+$/
  end

  context 'git' do
    let(:sample_repo_path) { "#{Dir.pwd}/.tmp/sample-repo" }

    before do
      FileUtils.rm_rf sample_repo_path if Dir.exist? sample_repo_path
      FileUtils.mkdir_p sample_repo_path
    end

    it 'sets up a git post-update hook' do
      run("sudo stat --format=%a #{remote_repo_path}/hooks/post-update").should =~ /^7/
      run("sudo readlink #{remote_repo_path}/hooks/post-update").should == "#{git_puppet_home}/git-post-update-hook"
    end

    it 'sets up git access for puppet-git user' do
      Dir.chdir sample_repo_path do
        init_and_push_repo :test => 'File contents'
        commit_delta.should == '0'
      end
    end
  end
end
