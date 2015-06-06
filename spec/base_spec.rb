require File.dirname(__FILE__) + '/spec_helper'

class Client0 < EM::Nodes::Client
  attr_reader :bla

  def post_init
    super
    @bla = 1
  end

  def unbind
    super
    @bla = 2
  end
end

class Server0 < EM::Nodes::Server
  attr_reader :bla

  def post_init
    super
    @bla = 1
  end

  def unbind
    super
    @bla = 2
  end
end

describe "Base spec" do
  it "base callbacks should work" do
    EM.run do
      host, port = (RUBY_PLATFORM =~ /java/) ? ['127.0.0.1', 19999] : ['/tmp/emn_server0.sock']
      $server0 = Server0.start(host, port)
      $client0 = Client0.connect(host, port)

      EM.next_tick do
        $client0.bla.should == 1
        $client0.alive.should == true

        $client00 = Server0.clients.first
        $client00.bla.should == 1
        $client00.alive.should == true
      end

      EM.add_timer(0.2) { EM.next_tick { EM.stop } }
    end

    $client0.bla.should == 2
    $client0.alive.should == false

    Server0.clients.size.should == 0
    $client00.bla.should == 2
    $client00.alive.should == false
  end
end
