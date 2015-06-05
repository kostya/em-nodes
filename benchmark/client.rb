require 'rubygems'
require "bundler/setup"
Bundler.require

class Client < EM::Nodes::DefaultClient
  def info
    { :name => "client" }
  end

  def on_task(task_id, data)
    send_task_result(task_id, data + 1)
  end
end

EM.run do
  puts "client run"
  EM.add_timer(0.1) do
    Client.connect '/tmp/test_em_nodes_sock'
  end
end
