require 'eventmachine'
require 'logger'
require 'em-nodes/em_hacks'

module EM::Nodes
  VERSION = "0.2"

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
end

require 'em-nodes/adapter'
