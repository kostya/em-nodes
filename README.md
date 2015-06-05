# EM::Nodes

Simple abstraction on top of EventMachine for easy create clients, servers, workers, ...

## Installation

Add this line to your application's Gemfile:

    gem 'em-nodes'

### How to use

Client should inherit from EM::Nodes::Client, Server should inherit from EM::Nodes::Server.
Client and Server can define and use methods `on_#{method_name}` and `send_#{method_name}`, `on_#{method_name}` - receive value from `send_#{method_name}` call.

Example: client after connection to server, send i_connected to server, server send_client_request, client on_client_request send to server client_responce, and server output value.

simple_server.rb
```ruby
class Server < EM::Nodes::Server
  def on_i_connected(value)
    puts "#{value} connected"
    send_client_request(1)
  end

  def on_client_responce(value)
    puts "client responce #{value}"
  end
end

EM.run do
  Server.start "/tmp/server.sock"
end
```

simple_client.rb
```ruby
class Client < EM::Nodes::Client
  def on_client_request(value)
    send_client_responce(value + 1)
  end
end

EM.run do
  client = Client.connect "/tmp/server.sock"
  client.send_i_connected("hahaha")
end
```

### HelloFeature

HelloFeature used to simple greetings between client and server. Client should define method `info` which return hash. Server had added method: `ready_clients`, which contain clients which answered on `info` method.

hello_server.rb
```ruby
class Server < EM::Nodes::Server
  include HelloFeature
end

EM.run do
  Server.start "/tmp/server.sock"

  EM.add_periodic_timer(5) do
    vasya = Server.ready_clients.detect { |client| client.data.my_name == 'Vasya' }
    vasya.send_die if vasya
  end
end
```

hello_client.rb
```ruby
class Client < EM::Nodes::Client
  include HelloFeature

  def initialize(name)
    @name = name
    super
  end

  def info
    { :my_name => @name }
  end

  def on_die
    puts "oops i should die"
    EM.stop
  end
end

EM.run do
  client = Client.connect "/tmp/server.sock", nil, "Vasya"
end
```

### TaskFeature

TaskFeature is simple task sending, executing and getting results. Client should define method `on_task(task_id, param)`, and when execute task and got results, should call `send_task_result(task_id, result)`. Server should send task with method, `send_task(param)`

Example: Client after connection send to server `get_me_task`, server send_task to client with rand value, client execute `on_task` method and add to param 1 and call `send_task_result`, server receive `on_task_result` and output result.

task_server.rb
```ruby
class Server < EM::Nodes::Server
  include TaskFeature

  def on_get_me_task
    param = rand
    puts "send to client #{param}"
    send_task(param)
  end

  def on_task_result(result)
    puts "client return result #{result}"
  end
end

EM.run do
  Server.start "/tmp/server.sock"
end
```

task_client.rb
```ruby
class Client < EM::Nodes::Client
  include TaskFeature

  def on_task(task_id, param)
    EM.next_tick { send_task_result(task_id, param + 1) }
  end
end

EM.run do
  client = Client.connect "/tmp/server.sock"
  client.send_get_me_task
end
```

### DefaultClient, DefaultServer

This is abstraction with HelloFeature and TaskFeature by default. Example how to create server and 10 workers. Server schedule for each client every 1 second, some value. Client just add 1 to value and return result to server, server puts value.

default_server.rb
```ruby
class Server < EM::Nodes::DefaultServer
  def on_task_result(res)
    puts res
  end
end

EM.run do
  Server.start "/tmp/server.sock"

  # periodical schedule tasks to clients
  EM.add_periodic_timer(1) do
    Server.ready_clients.each do |client|
      client.send_task(rand)
    end
  end
end
```

default_client.rb
```ruby
class Client < EM::Nodes::DefaultClient
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

[More examples](https://github.com/kostya/em-nodes/tree/master/examples)
