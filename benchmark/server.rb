require 'rubygems'
require "bundler/setup"
Bundler.require

CLIENTS_COUNT = 5
TASKS_COUNT = 100000

class Server < EM::Nodes::DefaultServer
  def on_task_result(res)
    $res_count += 1
    $res += res

    if $res_count >= TASKS_COUNT
      EM.next_tick { EM.stop }
    else
      send_task(res + 1)
    end
  end
end

$res = 0
$res_count = 0

tm = Time.now

EM.run do
  Server.start '/tmp/test_em_nodes_sock'

  tm = Time.now
  Thread.new do
    sleep 0.5 while Server.ready_clients.size < CLIENTS_COUNT
    tm = Time.now

    Server.ready_clients.each do |client|
      client.send_task(0)
    end
  end

end

puts "executed with #{Time.now - tm}, res: #{$res}, res_count: #{$res_count}"
