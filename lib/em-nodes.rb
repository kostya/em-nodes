require 'eventmachine'
require 'logger'

module EM::Nodes
  VERSION = "0.1"

  class << self
    def logger=(logger)
      @_logger = logger
    end

    def logger
      @_logger ||= Logger.new(STDOUT)
    end

    def exception(ex)
      logger.error "Exception: #{ex.message} #{ex.backtrace * "\n"}"
    end
  end

  autoload :Client,           'em-nodes/client'
  autoload :Server,           'em-nodes/server'
  autoload :Commands,         'em-nodes/commands'
  autoload :AbstractCommand,  'em-nodes/abstract_command'
end
