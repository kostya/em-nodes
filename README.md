# EM::Nodes

Simple abstraction on top of EventMachine for easy create clients, servers, workers, ...

## Installation

Add this line to your application's Gemfile:

    gem 'em-nodes'

### How to use

Client should inherit from EM::Nodes::Client, Server should inherit from EM::Nodes::Server

server.rb
```ruby
```

client.rb
```ruby
```

### HelloFeature

### TaskFeature

### DefaultClient, DefaultServer

This is abstraction with Hello and Task features by default. Example how to create server and 10 workers. Server schedule for each client every 1 second, some vale. Client just add 1 to value and return result to server, server puts value.

server.rb
```ruby
class Server < EM::Nodes::DefaultServer
  def on_task_result(res)
    puts res
  end
end

EM.run do
  Server.start "/tmp/server.sock"

  # periodical schedule tasks to clients
  EM.add_periodical_timer(1) do
    Server.ready_clients.each do |client|
      client.send_task(rand)
    end
  end
end
```

client.rb
```ruby
class Client < EM::Nodes::DefaultClient

  # info used in Hello feature, should return hash, with some client info
  def info
    { :name => 'bla' }
  end

  def on_task(task_id, param)
    res = do_something(param)
    send_task_result(task_id, res)
  end

  def do_something(x)
    x + 1
  end
end

EM.run do
  10.times do
    Client.connect "/tmp/server.sock"
  end
end
```
