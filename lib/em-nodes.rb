require 'eventmachine'
require 'logger'
require 'em-nodes/em_hacks'

module EM::Nodes
  class << self
    def logger=(logger)
      @_logger = logger
    end

    def logger
      @_logger ||= Logger.new(nil)
    end

    def exception(ex)
      logger.error "Exception: #{ex.message} #{ex.backtrace * "\n"}"
    end
  end

  autoload :Client,           'em-nodes/client'
  autoload :Server,           'em-nodes/server'
  autoload :Commands,         'em-nodes/commands'
  autoload :AbstractCommand,  'em-nodes/abstract_command'

  autoload :DefaultClient,    'em-nodes/default_client'
  autoload :DefaultServer,    'em-nodes/default_server'
end

require 'em-nodes/adapter'
