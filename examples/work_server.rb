require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Server < EM::Nodes::DefaultServer
  def on_task_result(new_x)
    puts new_x
    EM.stop
  end
end

EM.run do
  Server.start "/tmp/em_nodes_test.sock"
  
  Thread.new do
    puts "waiting for first client"
    sleep 0.5 while Server.ready_clients.count < 1

    Server.ready_clients.first.send_task(0)
  end
end
