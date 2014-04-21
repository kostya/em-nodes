require File.dirname(__FILE__) + '/spec_helper'

class Client3 < EM::Nodes::Client
  include Hello

  def info
    { :name => "vasya" }
  end
end

class Server3 < EM::Nodes::Server
  include Hello

  def on_i_am(params)
    super
    $client3_result = self.data
    $server3_ready_clients = Server3.ready_clients
    EM.stop
  end
end

describe "Hello spec" do
  it "should work" do
    EM.run do
      $server3 = Server3.start('127.0.0.1', 19994)
      $client3 = Client3.connect('127.0.0.1', 19994)
    end

    $client3_result.name.should == 'vasya'
    $server3_ready_clients.size.should == 1
  end
end
