# vim: set ts=2 sw=2 ai et ruler:
require 'spec_helper'
require 'tmpdir'

fixtures_path = File.expand_path('../../fixtures', __FILE__)

describe 'JumanjimanSpecHelper::Git' do
  before :each do
    # create a random dir name for stubbing a root dir
    @fake_repo_root = Dir.mktmpdir
  end
  after :each do
    FileUtils.rm_rf @fake_repo_root
  end

  describe 'repo_root' do
    before :each do
      @repo_root = JumanjimanSpecHelper::Git.repo_root
    end

    it 'is an absolute path' do
      Pathname.new(@repo_root).absolute?.should be_true
    end

    it 'contains .git dir' do
      Dir.entries(@repo_root).include?('.git').should be_true
    end

    it 'is accessible as RSpec.configuration.repo_root' do
      RSpec.configuration.method_exists?(:repo_root).should be_true
    end

    it 'RSpec.configuration.repo_root has correct value' do
      RSpec.configuration.repo_root.should == @repo_root
    end
  end

  describe 'git_config_path' do
    before :each do
      JumanjimanSpecHelper::Git.stubs(:repo_root).returns(@fake_repo_root)
      @path = JumanjimanSpecHelper::Git.git_config_path
    end

    it 'is an absolute path' do
      Pathname.new(@path).absolute?.should be_true
    end

    it 'returns path to .git/config' do
      @path.should == File.join(@fake_repo_root, '.git', 'config')
    end
  end

  describe 'repo_config_path' do
    before :each do
      JumanjimanSpecHelper::Git.stubs(:repo_root).returns(@fake_repo_root)
      @path = JumanjimanSpecHelper::Git.repo_config_path
    end

    it 'is an absolute path' do
      Pathname.new(@path).absolute?.should be_true
    end

    it 'returns path to .repo/config' do
      @path.should == File.join(@fake_repo_root, '.repo', 'config')
    end
  end

  describe 'config_data(path)' do
    it 'returns nil if path does not exist' do
      path = 'uhetansuhteoahutsheotsuhteoashutsanhoetusahtusha'
      JumanjimanSpecHelper::Git.config_data(path).should be_nil
    end

    it 'returns ini data if path exists' do
      path = File.join(fixtures_path, 'source.ini')
      data = IniFile.new(:filename => path).read
      data['unit test']['foo'].should == 'bar'
    end
  end

  describe 'update_git_config' do
    before :each do
      # fixtures
      @fix_source = File.join(fixtures_path, 'source.ini')
      @fix_target = File.join(fixtures_path, 'target.ini')

      # copy target to tmp dir
      @tmpdir = Dir.mktmpdir
      @tmp_target = File.join(@tmpdir, 'target.ini')
      FileUtils.cp @fix_target, @tmp_target

      # stub paths so we don't write target in repo
      JumanjimanSpecHelper::Git.stubs(:git_config_path).returns(@tmp_target)
      JumanjimanSpecHelper::Git.stubs(:repo_config_path).returns(@fix_source)

      # stub repo_path
      JumanjimanSpecHelper::Git.stubs(:repo_root).returns(@fake_repo_root)
    end

    after :each do
      FileUtils.rm_rf @tmpdir
    end

    describe 'rake task' do
      task_name = 'j:update_git_config'
      task_path = File.join('lib', 'jumanjiman_spec_helper', 'git.rb')

      it "is accessible as #{task_name}" do
        Rake::Task.task_defined?(task_name).should be_true
      end

      it 'calls update_git_config method' do
        # we stub the git config path above to protect against side effects
        JumanjimanSpecHelper::Git.expects(:update_git_config)
        Rake::Task[task_name].invoke
      end
    end

    context 'when .repo/config does not exist' do
      it 'does not change .git/config' do
        # override stub
        path = 'uhetansuhteoahutsheotsuhteoashutsanhoetusahtusha'
        JumanjimanSpecHelper::Git.stubs(:repo_config_path).returns(path)

        # update target
        JumanjimanSpecHelper::Git.update_git_config

        # target should not be changed
        FileUtils.cmp(@fix_target, @tmp_target).should be_true
      end
    end

    context 'when .repo/config exists' do
      before :each do
        # update target
        JumanjimanSpecHelper::Git.update_git_config

        # read target
        @data = IniFile.new(:filename => @tmp_target).read
      end

      it 'modifies .git/config' do
        FileUtils.cmp(@fix_target, @tmp_target).should be_false
      end

      it 'adds keys to .git/config' do
        @data['unit test']['foo'].should == 'bar'
      end

      it 'overrides keys in .git/config' do
        @data['commit']['template'].should =~ /\.repo/
      end

      it "substitutes 'REPO_ROOT' with real repo_root" do
        path = File.join(@fake_repo_root, '.repo', 'commit.template')
        @data['commit']['template'].should == path
      end

      it 'preserves keys in .git/config that are not in .repo/config' do
        @data['branch "master"']['remote'] == 'origin'
      end
    end
  end
end
