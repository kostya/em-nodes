require "bundler/setup"
Bundler.require

class ChatServer < EM::Nodes::Server
  def post_init
    super
    client.send_who_are_you?
  end

  def i_am(name)
    client.data.name = name
    to_all "> coming #{name} <"
  end

  def say(msg)
    to_all "#{client.data.name} say: #{msg}"
  end

  def to_all(msg)
    self.class.clients.each { |cl| cl.send_say("#{Time.now} - " + msg.to_s) }
  end

  def unbind
    super
    to_all("quiting #{client.data.name}")
  end
end

EM.run do
  ChatServer.start('127.0.0.1', 1999)
end
