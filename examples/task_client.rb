require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Client < EM::Nodes::Client
  include TaskFeature

  def on_task(task_id, param)
    EM.next_tick { send_task_result(task_id, param + 1) }
  end
end

EM.run do
  client = Client.connect "/tmp/server.sock"
  client.send_get_me_task
end
