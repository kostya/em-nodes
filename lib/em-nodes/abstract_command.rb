module EM::Nodes::AbstractCommand
  COMMAND_PREFIX = 'send_'

  def method_missing(method, *args)
    method = method.to_s

    unless method.start_with?(COMMAND_PREFIX)
      EM::Nodes.logger.debug "unknown send #{method} #{args.inspect}"
      super(method, *args)
      return
    end

    if @alive
      send_command(method.sub(COMMAND_PREFIX, ''), args)
    else
      EM::Nodes.logger.error "failed command attempt #{method}, connection dead"
    end
  end
end