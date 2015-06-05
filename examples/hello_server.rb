require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Server < EM::Nodes::Server
  include HelloFeature
end

EM.run do
  Server.start "/tmp/server.sock"

  EM.add_periodic_timer(5) do
    vasya = Server.ready_clients.detect { |client| client.data.my_name == 'Vasya' }
    vasya.send_die if vasya
  end
end
