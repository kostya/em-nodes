require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Client < EM::Nodes::Client
  def on_server_request(value)
  	puts "server send #{value}"
    send_client_responce(value + 1)
  end
end

EM.run do
  client = Client.connect "/tmp/server.sock"
  client.send_i_connected("hahaha")
end
