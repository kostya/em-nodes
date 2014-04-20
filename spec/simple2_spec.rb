require File.dirname(__FILE__) + '/spec_helper'

$pong = []

class Client2 < EM::Nodes::Client
  def on_pong(a)
    $pong << a
    EM.stop if $pong.size >= 2
  end
end

class Server2 < EM::Nodes::Server
  def on_ping(a)
    send_pong(a + 1)
  end
end

describe "Simple spec" do
  it "should work" do
    EM.run do
      $server2 = Server2.start('127.0.0.1', 19993)
      $client21 = Client2.connect('127.0.0.1', 19993)
      $client22 = Client2.connect('127.0.0.1', 19993)

      $client21.send_ping(1)
      $client22.send_ping(2)
    end

    $pong.should == [2, 3]
  end
end
