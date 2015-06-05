require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Client < EM::Nodes::Client
  include HelloFeature

  def initialize(name)
    @name = name
    super
  end

  def info
    { :my_name => @name }
  end

  def on_die
  	puts "oops i should die"
    EM.stop
  end
end

EM.run do
  client = Client.connect "/tmp/server.sock", nil, "Vasya"
end
