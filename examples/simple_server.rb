require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Server < EM::Nodes::Server
  def on_i_connected(value)
    puts "#{value} connected"
    send_server_request(1)
  end

  def on_client_responce(value)
    puts "client responce #{value}"
  end
end

EM.run do
  Server.start "/tmp/server.sock"
end
