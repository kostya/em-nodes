require 'socket'
require 'ostruct'

class EM::Nodes::Server < EM::Connection
  autoload :HelloFeature,  'em-nodes/server/hello'
  autoload :TaskFeature,   'em-nodes/server/task'

  include EM::P::ObjectProtocol
  include EM::Nodes::Commands

  class << self
    def clients
      @clients ||= []
    end

    def alive_clients
      clients.select &:alive
    end
  end

  attr_reader :data

  def accept?(host, port)
    true
  end

  def inactivity_timeout
    10 * 60 # 10 minutes default
  end

  def post_init
    @data = OpenStruct.new

    self.comm_inactivity_timeout = inactivity_timeout if EM.reactor_running?

    port, host = Socket.unpack_sockaddr_in(get_peername) rescue []
    unless accept?(host, port)
      unbind
      return
    end
    self.data.host = host
    self.data.port = port

    @alive = true
    self.class.clients << self
    EM::Nodes.logger.info { "Incomming connection from #{host}:#{port}" }
  end

  def unbind
    @alive = false
    self.class.clients.delete self
    EM::Nodes.logger.info { "Client #{self.data.inspect} has disconnected" }
  end

  def self.start(host, port = nil, *args)
    EM::Nodes.logger.info { "Start server #{host}:#{port}" }
    EM.start_server host, port, self, *args
  end
end

