require 'socket'
require 'ostruct'

class EM::Nodes::Server < EM::Connection
  autoload :Hello, 'em-nodes/server/hello'

  include EM::P::ObjectProtocol
  include EM::Nodes::Commands
  include EM::Nodes::AbstractCommand

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
    self.comm_inactivity_timeout = inactivity_timeout

    port, host = Socket.unpack_sockaddr_in(get_peername)
    unless accept?(host, port)
      unbind
      return
    end

    @data = OpenStruct.new
    @alive = true
    self.class.clients << self
    EM::Nodes.logger.info "Incomming connection from #{host}:#{port}"
  end

  def unbind
    @alive = false
    self.class.clients.delete self
    EM::Nodes.logger.info "Client has disconnected"
  end

  def self.start(host, port, *args)
    EM::Nodes.logger.info "start server on #{host}:#{port}"
    EM.start_server host, port, self, *args
  end
end
