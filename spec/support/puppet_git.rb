module PuppetGit
  def git_puppet_home
    '/var/lib/puppet-git-receiver'
  end

  def remote_repo_path
    "#{git_puppet_home}/puppet.git"
  end

  def remote_working_dir
    "#{git_puppet_home}/code"
  end

  def init_and_push_repo(file_contents = {}, path = Dir.pwd)
    Dir.chdir path do
      file_contents.each do |file_name, contents|
        file_name = file_name.to_s
        FileUtils.mkdir_p File.dirname(file_name)
        File.open(file_name, 'w') { |f| f.puts contents }
      end

      cmds = [
        'rm -rf .git',
        'git init',
        'git add .',
        'git commit -m "Initial commit"',
        "git remote add origin ssh://puppet-git@localhost:#{ssh_port}#{remote_repo_path}",
        'git push -f origin master 2>/dev/null'
      ]

      `#{cmds.join ' && '}`
      raise 'Unable to push' unless $?.exitstatus == 0
    end
  end

  def commit_and_push_repo(path = Dir.pwd)
    Dir.chdir test_repo_path do
      cmds = [
        'git add -A .',
        'git commit -m "Updated!"',
        'git push -f origin master 2>/dev/null'
      ]

      `#{cmds.join ' && '}`
      raise 'Unable to push' unless $?.exitstatus == 0
    end
  end

  def commit_delta(path = Dir.pwd)
    `cd #{path} && git rev-list origin/master..master  2>/dev/null | awk 'END {print NR}'`.strip
  end
end
