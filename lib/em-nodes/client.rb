class EM::Nodes::Client < EM::Connection
  autoload :HelloFeature,  'em-nodes/client/hello'
  autoload :TaskFeature,   'em-nodes/client/task'

  include EM::P::ObjectProtocol
  include EM::Nodes::Commands

  attr_reader :alive

  def post_init
    @alive = true
  end

  def unbind
    @alive = false
    EM::Nodes.logger.warn { "Connection has terminated" }
  end

  def self.connect(host, port = nil, *args, &block)
    EM::Nodes.logger.info { "Connecting to server #{host}:#{port}" }
    EM.connect(host, port, self, *args)
  end
end
