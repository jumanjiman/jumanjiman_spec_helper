# vim: set ts=2 sw=2 ai et ruler:
require 'spec_helper'

fixtures_path = File.expand_path('../../fixtures', __FILE__)

# Other rspec examples depend on the content of these fixtures,
# so we detect accidental change that could cause side effects.
describe 'spec/fixtures' do
  fixtures = {
    'source.ini'   => '403d536f49e2142ea9af9296e56c4f7f',
    'target.ini'   => 'a9e7ac8cee79e417f31ec2a97201ba9c',
  }

  fixtures.each do |file, md5sum|
    it "#{file} has the expected content" do
      path = File.join(fixtures_path, file)
      Digest::MD5.hexdigest(File.read(path)).should == md5sum
    end
  end
end
