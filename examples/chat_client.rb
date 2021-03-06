require "bundler/setup"
Bundler.require
require 'irb'

class ChatClient < EM::Nodes::Client
  def initialize(name)
    @name = name
    super
  end

  def on_who_are_you?
    send_i_am @name
  end

  def on_say(msg)
    puts msg
  end

  def unbind
    super
    EM.stop
  end
end

def say(msg)
  $cl.send_say(msg)
end

EM.run do
  $cl = ChatClient.connect "127.0.0.1", 1999, ARGV.shift || "Vasya"

  Thread.new do
    IRB.start
    EM.stop
  end
end
