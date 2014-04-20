require 'rubygems'
require 'bundler/setup'

EM::Nodes.logger = Logger.new(File.dirname(__FILE__) + "/spec.log")
