class EM::Nodes::Client < EM::Connection
  autoload :HelloFeature,  'em-nodes/client/hello'
  autoload :TaskFeature,   'em-nodes/client/task'

  include EM::P::ObjectProtocol
  include EM::Nodes::Commands
  include EM::Nodes::AbstractCommand

  def post_init
    @alive = true
    EM::Nodes.logger.info { "Connected to server" }
  end

  def unbind
    @alive = false
    EM::Nodes.logger.warn { "Connection has terminated" }
  end

  def self.connect(host, port = nil, *args, &block)
    EM.connect(host, port, self, *args)
  end
end
