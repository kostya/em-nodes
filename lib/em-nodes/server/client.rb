require 'ostruct'

class EM::Nodes::Server::Client
  include EM::Nodes::AbstractCommand

  attr_accessor :connection, :alive
  attr_reader :data

  def initialize(conn)
    @connection = conn
    @alive = true
    @data = OpenStruct.new
  end

  def disconnect!
    @alive = false
  end
end