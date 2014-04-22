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
    EM.schedule { send_object [method.to_s, args] }
  end

  COMMAND_PREFIX = 'send_'

  def method_missing(method, *args)
    method = method.to_s

    unless method.start_with?(COMMAND_PREFIX)
      EM::Nodes.logger.warn { "unknown send :#{method} #{args.inspect}" }
      super(method, *args)
      return
    end

    if @alive
      send_command(method[5..-1], args)
    else
      EM::Nodes.logger.error { "failed command attempt #{method}, connection dead" }
    end
  end

end
