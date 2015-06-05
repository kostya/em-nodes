require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Server < EM::Nodes::Server
  include TaskFeature

  def on_get_me_task
    param = rand
    puts "send to client #{param}"
    send_task(param)
  end

  def on_task_result(result)
    puts "client return result #{result}"
  end
end

EM.run do
  Server.start "/tmp/server.sock"
end
