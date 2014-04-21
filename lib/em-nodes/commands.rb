module EM::Nodes::Commands
  def receive_object(h)
    unless h.is_a?(Hash)
      EM::Nodes.logger.error "received unknown object: #{h.inspect}"
      return
    end

    method = "on_#{h[:method]}"
    args = h[:args]
    t = Time.now
    send(method, *args)
    EM::Nodes.logger.debug "<= #{method} #{args.inspect} (#{Time.now - t}s)"

  rescue Object => ex
    EM::Nodes.exception(ex)
  end

  def send_command(method, args)
    obj = {:method => method, :args => args}
    EM::Nodes.logger.debug "=> #{method}"
    EM.schedule { send_object(obj) }
  end
end
