require File.dirname(__FILE__) + '/spec_helper'

class Waiter
  attr_accessor :time
  def initialize(conn, task_id)
    @time = Time.now
    EM.add_timer(1) { conn.send_task_result(task_id, true) }
  end
end

class Client5 < EM::Nodes::Client
  include TaskFeature

  def on_task(task_id, data)
    Waiter.new(self, task_id)    
  end
end


class Server5 < EM::Nodes::Server
  include TaskFeature

  def on_task_result(res)
    $server5_results << res
    EM.stop if $server5_results.size == 10
  end
end

describe "write task object, to prevent GC" do
  before {
    $server5_results = []
  }

  it "should work" do
    client5 = nil
    EM.run do
      $server5 = Server5.start('127.0.0.1', 19997)
      $client5 = Client5.connect('127.0.0.1', 19997)

      EM.add_timer(0.1) do
        client5 = Server5.clients.first
        10.times { |i| client5.send_task(i) }
      end

      EM.add_timer(0.5) do
        $server5_results.should be_empty
        $client5.tasks.size.should == 10
        $client5.tasks.values.map(&:time).compact.size.should == 10
      end
    end

    $server5_results.size.should == 10
    $client5.tasks.size.should == 0
  end
end
