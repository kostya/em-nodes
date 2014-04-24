module EventMachine
  class << self
    def pool_size
      @threadqueue ? @threadqueue.size : 0
    end
  end
end
