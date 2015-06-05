require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Server < EM::Nodes::DefaultServer
  def on_task_result(res)
    puts res
  end
end

EM.run do
  Server.start "127.0.0.1", 8888

  # periodical schedule tasks to clients
  EM.add_periodic_timer(1) do
    Server.ready_clients.each do |client|
      client.send_task(rand)
    end
  end
end
