class EM::Nodes::Client
  module HelloFeature

    def on_who_are_you?
      i = info
      raise "info should be a Hash, but not #{i.inspect}" unless i.is_a?(Hash)
      send_i_am(i.merge(__default_info__))
    end

    def info
      {} # redefine me
    end

  private

    def __default_info__
      { :hostname => (`hostname` rescue "").chop }
    end

  end
end
