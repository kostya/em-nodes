require 'drb'

class DrbClient
  def task(data)
    data + 1
  end
end

i = ARGV[0] || '0'
DRb.start_service("druby://127.0.0.1:111#{i}", DrbClient.new)
sleep
