module EM::Nodes::Commands
  def receive_object(h)
    method, args = h
    method = 'on_' + method
    t = Time.now
    send(method, *args)
    EM::Nodes.logger.debug { "<= #{method} #{args.inspect} (#{Time.now - t}s)" }

  rescue Object => ex
    EM::Nodes.exception(ex)
  end

  def send_command(method, args)
    EM::Nodes.logger.debug { "=> #{method}" }
    EM.schedule { send_object([method, args]) }
  end
end
