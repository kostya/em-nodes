# try to autodetect ruby-app application

if defined?(Application) && Application.respond_to?(:logger)
  EM::Nodes.logger = Application.logger
end

if defined?(ErrorMailer)
  module EM::Nodes
    class << self
      def exception(ex)
        ErrorMailer.exception(ex)
      end
    end
  end
end

# try to autodetect rails application
# todo:
