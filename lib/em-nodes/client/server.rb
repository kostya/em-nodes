class EM::Nodes::Client::Server
  include EM::Nodes::AbstractCommand

  attr_accessor :connection, :alive
  def initialize(conn)
    @connection = conn
    @alive = true
  end

  def disconnect!
    @alive = false
  end
end
