require 'rubygems'
require 'bundler/setup'
Bundler.require

EM::Nodes.logger = Logger.new(File.dirname(__FILE__) + "/spec.log")
RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
end
