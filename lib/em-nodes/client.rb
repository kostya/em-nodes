class EM::Nodes::Client < EM::Connection
  autoload :Hello, 'em-nodes/client/hello'

  include EM::P::ObjectProtocol
  include EM::Nodes::Commands
  include EM::Nodes::AbstractCommand

  def post_init
    @alive = true
    EM::Nodes.logger.debug "Connected to server"
  end

  def unbind
    @alive = false
    EM::Nodes.logger.warn "connection has terminated"
  end

  def self.connect(host, port, *args, &block)
    EM.connect(host, port, self, *args)
  end
end
