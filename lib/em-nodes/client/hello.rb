module EM::Nodes::Client::Hello
  def who_are_you?
    i = info
    raise "info should be a Hash, but not #{i.inspect}" unless i.is_a?(Hash)
    send_i_am(i)
  end

  def info
    raise "implement me"
  end
end