require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Client < EM::Nodes::DefaultClient
  def info
    { :name => "client" }
  end
  
  def on_task(task_id, x)
    new_x = x + 1
    send_task_result(task_id, new_x)
  end
end

EM.run do
  Client.connect "/tmp/em_nodes_test.sock"
end
