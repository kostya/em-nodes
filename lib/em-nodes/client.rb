class EM::Nodes::Client < EM::Connection
  autoload :Server, 'em-nodes/client/server'

  attr_reader :server

  include EM::P::ObjectProtocol
  include EM::Nodes::Commands

  def post_init
    @server = EM::Nodes::Client::Server.new(self)
    EM::Nodes.logger.debug "Connected to server"
  end

  def unbind
    @server.disconnect!
    EM::Nodes.logger.warn "connection has terminated"
  end

  def self.connect(host, port, *args, &block)
    EM.connect(host, port, self, *args)
  end
end
