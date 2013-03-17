# vim: set ts=2 sw=2 ai et ruler:
require 'spec_helper'

describe '.repo/config' do
  it 'does not use ssh for upstream remote' do
    lines = MiniGit::Capturing.remote(:show, :upstream, :n => true).lines
    /git@/.should_not match lines.grep(/Fetch URL/).first
  end
end
