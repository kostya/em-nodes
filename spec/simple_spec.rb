require File.dirname(__FILE__) + '/spec_helper'

class Client1 < EM::Nodes::Client
  def initialize(name)
    @name = name
    super
  end

  def on_who_are_you?
    send_i_am @name
  end

  def unbind
    super
    EM.stop
  end
end

class Server1 < EM::Nodes::Server
  def post_init
    super
    send_who_are_you?
  end

  def on_i_am(name)
    self.data.name = name
    $client1_result = { :name => name, :clients => Server1.clients.clone }
    EM.stop
  end
end

describe "Simple spec" do
  it "should work" do
    EM.run do
      $server1 = Server1.start('127.0.0.1', 19992)
      $client1 = Client1.connect('127.0.0.1', 19992, "haha")
    end

    $client1.should be_a(Client1)

    $client1_result[:name].should == "haha"
    $client1_result[:clients].size.should == 1
  end
end
