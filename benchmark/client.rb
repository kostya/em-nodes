require 'rubygems'
require "bundler/setup"
Bundler.require

class Client < EM::Nodes::Client
  include Hello
  include Task

  def info
    { :name => "client" }
  end

  def on_task(task_id, data)
    send_task_result(task_id, data + 1)
  end

  def unbind
    super
    EM.stop
  end
end

EM.run do
  puts "client run"
  Client.connect '/tmp/test_em_nodes_sock'
end

