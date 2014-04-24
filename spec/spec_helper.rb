require 'rubygems'
require 'bundler/setup'
Bundler.require

EM::Nodes.logger = Logger.new(File.dirname(__FILE__) + "/spec.log")
