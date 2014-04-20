module EM::Nodes::Server::Hello
  def post_init
    super
    send_who_are_you?
  end

  def on_i_am(params)
    params.each do |key, value|
      self.data[key] = value
    end

    self.data.trusted = true
  end
end
