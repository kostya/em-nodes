require 'bundler/setup'
Bundler.require
require 'logger'

l = Logger.new(STDOUT)
l.level = Logger::INFO
EM::Nodes.logger = l

class Client < EM::Nodes::DefaultClient

  # info used in Hello feature, should return hash, with some client info
  def info
    { :name => 'bla' }
  end

  def on_task(task_id, param)
    res = do_something(param)
    send_task_result(task_id, res)
  end

  def do_something(x)
    x + 1
  end
end

EM.run do
  10.times do
    Client.connect "/tmp/server.sock"
  end
end
