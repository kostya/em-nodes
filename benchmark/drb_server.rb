require 'drb'

CLIENTS_COUNT = 5
TASKS_COUNT = 100000

DRb.start_service
clients = []
CLIENTS_COUNT.times do |i|
  clients << DRbObject.new(nil, "druby://127.0.0.1:111#{i}")
end

puts "start with clients #{clients.size}"

$res = 0
$res_count = 0
$mutex = Mutex.new

tm = Time.now 
clients.map do |cl|
  Thread.new do
    data = 0
    loop do
      data = cl.task(data)
      $mutex.synchronize do
        $res_count += 1
        $res += data
        if $res_count >= TASKS_COUNT          
          puts "executed with #{Time.now - tm}, res: #{$res}, res_count: #{$res_count}"
          exit
        end
      end
    end
  end
end.each &:join
