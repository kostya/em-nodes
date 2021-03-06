require File.dirname(__FILE__) + '/spec_helper'


class Client4 < EM::Nodes::Client
  include TaskFeature

  def on_task(task_id, data)
    $client4_results << data
    send_task_result(task_id, data + 1)  if $client4_results.size <= 10
  end
end

class Server4 < EM::Nodes::Server
  include TaskFeature

  def on_task_result(res)
    $server4_results << res
    EM.next_tick { EM.stop } if $server4_results.size >= 10
  end

  def on_reschedule_tasks(values)
    $server4_unbind_results = values
  end
end

describe "Task spec" do
  before {
    $client4_results = []
    $server4_results = []
    $server4_unbind_results = []
  }

  it "should work" do
    client4 = nil
    EM.run do
      $server4 = Server4.start('127.0.0.1', 19995)
      sleep 0.1
      $client4 = Client4.connect('127.0.0.1', 19995)

      EM.add_timer(0.1) do
        client4 = Server4.clients.first
        10.times { |i| client4.send_task(i) }
      end
    end

    $server4_results.should == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    $server4_unbind_results.should == []
    client4.task_count.should == 0
  end

  it "on unbind" do
    EM.run do
      $server4 = Server4.start('127.0.0.1', 19996)
      $client4 = Client4.connect('127.0.0.1', 19996)

      EM.add_timer(0.1) do
        client4 = Server4.clients.first
        20.times { |i| client4.send_task(i) }
      end
    end

    $server4_results.should == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    $server4_unbind_results.sort.should == [10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
  end
end
