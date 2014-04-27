class EM::Nodes::DefaultClient < EM::Nodes::Client
  include HelloFeature
  include TaskFeature

  def unbind
    super    
    EM.next_tick { EM.stop }
  end
end
