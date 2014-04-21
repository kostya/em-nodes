class EM::Nodes::Server
  module HelloFeature
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def ready_clients
        clients.select{ |cl| cl.data.ready }
      end
    end

    def post_init
      super
      send_who_are_you?
    end

    def on_i_am(params)
      params.each do |key, value|
        self.data.send "#{key}=", value
      end

      self.data.ready = true
    end
  end
end
