# vim: set ts=2 sw=2 ai et ruler:
require 'rake'
require 'rspec'

module JumanjimanSpecHelper
  class Git
    require 'inifile'
    require 'minigit'

    def self.repo_root
      ENV['GIT_PAGER'] = '' # https://github.com/3ofcoins/minigit#issues
      repo_root ||= MiniGit.new(Dir.pwd).git_work_tree
    end

    def self.config_data(path)
      IniFile.new(:filename => path).read
    end

    def self.git_config_path
      File.join(repo_root, '.git', 'config')
    end

    def self.repo_config_path
      File.join(repo_root, '.repo', 'config')
    end

    def self.update_git_config
      repo_data = config_data(repo_config_path)
      if repo_data
        git_data = config_data(git_config_path)
        repo_data.each do |sect, param, val|
          git_data[sect][param] = val.gsub(/REPO_ROOT/, repo_root)
        end
        i = IniFile.new(:filename => git_config_path).read.merge(git_data)
        i.save
      end
    end
  end
end

namespace :j do
  desc 'Merge .repo/config into .git/config'
  task :update_git_config do
    JumanjimanSpecHelper::Git.update_git_config
  end
end

RSpec.configure do |c|
  c.add_setting 'repo_root', :default => JumanjimanSpecHelper::Git.repo_root
end
